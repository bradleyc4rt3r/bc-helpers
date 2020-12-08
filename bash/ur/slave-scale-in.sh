#!/bin/bash
set -x

sleep_time=20
ipv4=$(ifconfig | grep inet | head -n 1 | awk '{print $2}')
termination_time=$(date -d "$TIME 5min" +"%H:%M")
instance_id=$(ec2metadata --instance-id)
slack_webhook=https://hooks.slack.com/services/****************
availability_zone="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"
region="${availability_zone::-1}"

cpu_5_minute_avg(){
        if [[ $ipv4 != "10.100.1.132" ]] && [[ $ipv4 != "10.100.1.188" ]] && [[ $ipv4 != "10.3.5.236" ]]; then
                echo -e "\033[0;31mCalculating 5 minute CPU average please wait..\033[0m"
                cpu_5min_avg=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) ; }' <(grep 'cpu ' /proc/stat) <(sleep $sleep_time ;grep 'cpu ' /proc/stat))
        else
                echo -e "\e[32mMaster found, cannot terminate, finding next slave...\033[0m"
}

terminate_slave(){
        aws ec2 terminate-instances --instance-ids "$instance_id" --region $region
}

detach_slave(){
        aws autoscaling detach-instances --instance-ids $instance_id --auto-scaling-group-name $environment-jenkins-slave --should-decrement-desired-capacity
}

send_slack_alert() {
        curl -X POST --data-urlencode "$PAYLOAD" "$slack_webhook"
}

set_5_minute_timer(){
        for (( i=$sleep_time; i>0; i--)); do
            sleep 1 &
            echo "$i"
            wait
            done
}

detect_environment(){
        if [[ $region == *"eu-west-2"* ]]; then
                echo "Region: London"
                environment="core"
        fi

        if [[ $region == *"eu-west-1"* ]]; then
                echo "Region: Ireland"
                environment="eu1"
        fi

        if [[ $region == *"us-east-1"* ]]; then
                echo "Region: North Virginia"
                environment="US1"
        fi

        if [[ $region == *"us-west-1"* ]]; then
                echo == "Region: North California"
                environment="us2"
        fi

        if [[ $region == *"ca-central-1"* ]]; then
                echo "Region: Region: Canada"
                environment="ca1"
        fi
}

generate_slave_aws_link(){
        asg_name="$environment"-jenkins-slave
        slave_asg_link="https://${region}.console.aws.amazon.com/ec2/autoscaling/home?region=${region}#AutoScalingGroups:id=${environment}-jenkins-slave;view=details"
}

set_desired(){

        current_desired=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "$asg_name" --region "$region" | grep Desired | sed 's/[^0-9]*//g')
        new_desired=$(($desired-1))
        aws autoscaling set-desired-capacity --region $region --auto-scaling-group-name $environment-jenkins-slave --desired-capacity $new_desired
}

detect_environment
generate_slave_aws_link

PAYLOAD='payload={      
    "text": "*warning:*, terminating idle slave at '$termination_time'",
    "blocks": [
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*----------- Idle Slave Found -----------*"
            }
        },
        {
                "type": "section",
                "fields": [{
                        "type": "mrkdwn",
                        "text": "*Instance ID:*\n'$instance_id'"
                    },
                    {
                        "type": "mrkdwn",
                        "text": "*Termination Time:*\n'$termination_time'"
                    },
                    {
                        "type": "mrkdwn",
                        "text": "*IP Address:*\n'$ipv4'"
                    },
                    {
                        "type": "mrkdwn",
                        "text": "*5 Minute CPU Average:*\n'$cpu_5min_avg'%" 
                    }
                ]
            },
            {
                "type": "actions",
                "elements": [{
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "emoji": true,
                            "text": "Jenkins Home"
                        },
                        "url": "https://jenkins-new.devweasel.net",
                        "style": "primary",
                        "value": "click_me"
                    },
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "emoji": true,
                            "text": "View Slaves"
                        },
                        "url": "https://jenkins-new.devweasel.net/computer",
                        "style": "primary",
                        "value": "click_me"
                    },
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "emoji": true,
                            "text": "View ASG"
                        },
                        "url": "'$slave_asg_link'",
                        "style": "primary",
                        "value": "click_me"
                }
            ]
        }
    ]
}'

slave_check() {
        if (( $(echo "$cpu_5min_avg < 1" | bc -l) )); then
            echo -e "\033[1;31mIdle slave found with: $cpu_5min_avg% CPU 5 minute average\033[0m"
            send_slack_alert
            set_5_minute_timer
            detach_slave
            sleep 5
            terminate_slave
        
        else
            echo -e "\e[32mSlave has $cpu_5min_avg% CPU, finding next slave...\033[0m"
        fi
}
slave_check

scale_out(){

        aws autoscaling set-desired-capacity --auto-scaling-group-name $environment-jenkins-slave --desired-capacity $scale_out_capacity

}

set +x
