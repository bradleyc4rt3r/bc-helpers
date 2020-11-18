#!/usr/bin/python3

import boto3
import requests
import os
import json
from time import sleep


print('BC EBS Mount Boot Starting.')

try:
    print('Fetching instance metadata...')
    availability_zone = requests.get('http://169.254.169.254/latest/meta-data/placement/availability-zone')
    availability_zone = availability_zone.text
    print('Availability Zone: ' + availability_zone)

    region = availability_zone[:-1]
    print('Region: ' + region)

    instance_id = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
    instance_id = instance_id.text
    print('Instance ID: ' + instance_id)
except Exception as e:
    print('Could not fetch instance metadata. Cannot proceed. Exiting.')
    print(e)
    exit(1)

try:
    print('Creating boto3 ec2 client and resource...')
    ec2 = boto3.client('ec2', region_name=region)
    ec2_resource = boto3.resource('ec2', region_name=region)
except Exception as e:
    print('Failed to create boto3 clients. Cannot proceeed. Exiting.')
    print(e)
    exit(1)


try:
    print('Processing instance tags...')
    instance = ec2_resource.Instance(instance_id)
    for tag in instance.tags:
        print('Tag: ' + tag["Key"] + ': ' + tag["Value"])

        if tag["Key"] == "BCMeta":
            print('BC metadata tag found.')
            meta = json.loads(tag["Value"])
            volume_id = meta['ebs-mount-boot']['volume_id']
            mount_point = meta['ebs-mount-boot']['path']

            if 'filesystem' in meta['ebs-mount-boot']:
                filesystem = meta['ebs-mount-boot']['filesystem']
            else:
                filesystem = False

            if 'owner' in meta['ebs-mount-boot']:
                owner = meta['ebs-mount-boot']['owner']
            else:
                owner = False

            print('Volume ID ' + volume_id + ' with mount point ' + mount_point + ' found in metadata.')
except Exception as e:
    print('Failed to process instance tags. Cannot proceed. Exiting.')
    print(e)
    exit(1)


if not os.path.exists(mount_point):
    try:
        print('Creating mount point ' + mount_point)
        os.mkdir(mount_point)
    except Exception:
        print('Failed to create mount point ' + mount_point)


try:
    print('Checking if the volume is already mounted to ' + mount_point)
    if os.path.ismount(mount_point):
        print('Volume already mounted. Exiting.')
        exit(0)
    else:
        print('Volume not mounted. Continuing...')
except Exception:
    print('Failed to check if volume mounted. Cannot proceed. Exiting.')
    exit(1)

try:
    volume_id
except Exception as e:
    print('Volume ID not found. Cannot proceed. Exiting.')
    print(e)
    exit(1)


try:
    print('Checking if volume attached...')
    if os.path.exists('/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_' + volume_id.replace('-', '')):
        print('Volume already attached.')
    else:
        print('Volume not attached. Attaching volume ' + volume_id)
        response = ec2.attach_volume(
            Device='/dev/sdb',
            InstanceId=instance_id,
            VolumeId=volume_id
        )
        print('Attached volume ' + volume_id)
except Exception as e:
    print('Could not attach EBS volume.')
    print(e)
    exit(1)


try:
    if filesystem:
        while not os.path.exists('/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_' + volume_id.replace('-', '')):
            print('Waiting for device to become available...')
            sleep(1)
        os.system('mkfs.' + str(filesystem) + ' /dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_' + volume_id.replace('-', ''))
except Exception as e:
    print('Failed to format filesystem. Device maybe already formatted.')
    print(e)

try:
    mounted = False
    while True:
        print('Mounting volume ' + volume_id + ' ' + mount_point)
        response = os.system('mount /dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_' + volume_id.replace('-', '') + ' ' + mount_point)
        if not response:
            mounted = True
            break
        sleep(1)
except Exception as e:
    print('Could not mount volume. Cannot proceed. Exiting.')
    print(e)
    exit(1)

if owner:
    try:
        print('Setting mount point owner')
        os.system('chown -R ' + str(owner) + ': ' + mount_point)
    except Exception as e:
        print('Failed to set mount point owner')
        print(e)

print('Volume mount successfully completed. Exiting.')
exit(0)
