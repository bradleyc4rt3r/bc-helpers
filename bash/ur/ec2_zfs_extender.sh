#!/bin/bash
set -x

size=1024
retry_count=0
customer=$(cat /opt/customer)
region="${availability_zone::-1}"
instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"
availability_zone="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"

detect_environment(){
  if [[ $region == *"eu-west-2"* ]]; then
          echo "Region: London"
          environment="core"
  elif [[ $region == *"eu-west-1"* ]]; then
          echo "Region: Ireland"
          environment="eu1"
  elif [[ $region == *"us-east-1"* ]]; then
          echo "Region: North Virginia"
          environment="us1"
  elif [[ $region == *"us-west-1"* ]]; then
          echo "Region: North California"
          environment="us2"
  elif [[ $region == *"ca-central-1"* ]]; then
          echo "Region: Canada"
          environment="ca1"
  else
    echo "Failure - Region ${region} not recognised"
          environment=""
          exit 1
  fi
}

create_volume(){
  volume_type="standard"
  echo "Creating volume please wait.."
  detect_environment
  detect_customer
  volume_creation_output=$(aws ec2 create-volume --availability-zone $availability_zone --volume-type $volume_type --size $size --region $region --tag-specifications "ResourceType=volume,Tags=[{Key=Customer,Value=${customer}},{Key=Role,Value=content}, {Key=Name,Value=${environment}-content-${customer}}]")
  sleep 3
}

fetch_volume_id(){
  volume_id=$(echo $volume_creation_output | sed -n s'/.*VolumeId//p' | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
  echo "Volume_id: ${volume_id}"
  sleep 20
}

detect_current_device_name(){
  current_device="$(lsblk -f | tail -n 3 | head -n 1)"
  echo "Most recent device name: /dev/${current_device}"
}

generate_next_device_name(){
  current_letter="$(lsblk -f | tail -n 3 | head -n 1 | cut -c 4)"
  next_letter="$(echo $current_letter | tr '[a-y]z' '[b-z]a')"
  new_device="/dev/xvd${next_letter}"
  echo "Next device name: ${new_device}"
}

poll_disk_state(){
  state="$(aws ec2 describe-volumes --region $region --volume-ids $volume_id --output table | grep State | sed 's/|//g' | awk '{print $2}' | head -n 1)"
  wait
  sleep 5
}

calculate_memory_usage(){
  memory_usage="$(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.0f%%)\n", $3,$2,$3*100/$2 }')"
  memory_percentage=$(echo ${memory_usage:27:2})
}

detach_disk(){
  echo "Detaching device"
  aws ec2 detach-volume --volume-id $volume_id --force
  sleep 60
}

restart_contentserver(){
  echo "Restarting contentserver process"
  service contentserver restart
  sleep 5
}

send_opsgenie_alert(){
  #send alert
  send #####
}

enable_offloading(){
  curl --user deploy:1193e54f6cfa5359cafddec13541311518 "https://jenkins-new.devweasel.net/job/devops/job/offload-enable/buildWithParameters?token=OFFLOADON&customer=${customer}"
}

disable_offloading(){
  echo "Disabling offloading"
  curl --user deploy:1193e54f6cfa5359cafddec13541311518 "https://jenkins-new.devweasel.net/job/devops/job/offload-disable/buildWithParameters?token=OFFLOADOFF&customer=${customer}"
}

handle_attachment_failure(){
  retry_count=$((retry_count+1))
  detach_disk
  echo "Failure - Device has not been attached, calculating memory usage"
  calculate_memory_usage; echo "${memory_usage}"

  if [[ ${memory_percentage} -gt 90 ]] && [[ ${retry_count} == 1 ]]; then
    echo "Memory usage too high for disk attachment, asking Jenkins to offload and retry..."
    enable_offloading
    sleep 300
    attach_disk

  elif [[ ${memory_percentage} -lt 90 ]] && [[ ${retry_count} == 1 ]]; then
    echo "Memory usage should be sufficient for volume attachment, dropping caches and retrying again..."
    sysctl -w vm.drop_caches=3
    wait
    attach_disk

  elif [[ ${retry_count} == 2 ]]; then
    echo "Attachment retry failed again, restarting contentserver process and trying for the final time..."
    attach_disk

  elif [[ ${retry_count} == 3 ]]; then
    echo "\e[31mAll retries failed, sending opsgenie alert\e[0m"
    disable_offloading
    send_opsgenie_alert
    exit 1

  fi
}

attach_disk(){
  state="null"
  while [ "$state" != "available" ]; do
      poll_disk_state
      sleep 2
  done

  if [[ "$state" == "available" ]]; then
      echo "Attaching ${volume_id}"
      aws ec2 attach-volume --device $new_device --instance-id $instance_id --volume-id $volume_id --region $region
      sleep 30
      detect_current_device_name

      while [[ "$state" == "available" ]]; do
        poll_disk_state
      done

      if [[ "$state" == "in-use" ]]; then 
          if [[ "${current_device}" != "${new_device}" ]]; then
            echo "Failure - Device has not been attached correctly, memory may be too high"
            handle_attachment_failure

          elif [[ "${current_devce}" == "${new_device}" ]]; then
            echo "Volume successfully attached\nNew device detected: ${new_device}, adding it to the zfs pool"
            disable_offloading
            zpool add storagestore $new_device
            wait
            sleep 20

            current_letter="$(lsblk -f | tail -n 3 | head -n 1 | cut -c 4)"
            if [[ "${new_device}" == "/dev/xvd${current_letter}" ]]; then
                echo "Pool expanded successfully"
            else
                echo "Failure - Mistmatch - Calculated next device name does not match the true name"
                exit 1
            fi
          fi
      fi
  fi
}

create_volume
fetch_volume_id
detect_current_device_name
generate_next_device_name
attach_disk

set +x

