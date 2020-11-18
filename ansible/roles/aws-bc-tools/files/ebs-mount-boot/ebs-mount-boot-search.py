#!/usr/bin/python3

import boto3
import requests
import os
import configparser
import json


print('BC EBS Mount Boot Starting.')
search_volumes = True

try:
    print('Reading /etc/bc.ini')
    config = configparser.ConfigParser()
    config.read('/etc/bc.ini')
    mount_point = config['ebs-mount-boot']['mount_point']
    volume_name = config['ebs-mount-boot']['name']
except Exception:
    print('Could not read config file. Cannot proceed. Exiting.')
    exit(1)

try:
    print('Fetching instance metadata...')
    availability_zone = requests.get('http://169.254.169.254/latest/meta-data/placement/availability-zone')
    availability_zone = availability_zone.text

    region = availability_zone[:-1]

    instance_id = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
    instance_id = instance_id.text
except Exception:
    print('Could not fetch instance metadata. Cannot proceed. Exiting.')
    exit(1)

try:
    print('Creating boto3 ec2 client and resource...')
    ec2 = boto3.client('ec2')
    ec2_resource = boto3.resource('ec2')
except Exception:
    print('Failed to create boto3 clients. Cannot proceeed. Exiting.')
    exit(1)

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
    print('Processing instance tags...')
    instance = ec2_resource.Instance(instance_id)
    for tag in instance.tags:
        if tag["Key"] == "Name":
            instance_name = tag["Value"]

        if tag["Key"] == "Environment":
            environment = tag["Value"]

        if tag["Key" == "Role"]:
            role = tag["Value"]

        if tag["Key" == "IC-Meta"]:
            print('Imagicloud metadata tag found.')
            meta = json.loads(tag["Value"])

            if meta['ebs-mount-point']:
                volume_id = meta['ebs-mount-point']['volume_id']
                mount_point = meta['ebs-mount-point']['path']
                search_volumes = False

                print('Volume ID ' + volume_id + ' with mount point ' + mount_point + ' found in metadata.')

except Exception:
    print('Failed to process instance tags. Cannot proceed. Exiting.')
    exit(1)

if search_volumes:
    try:
        print('Searching for EBS volumes...')
        volumes = ec2.describe_volumes(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values': [
                        volume_name
                    ]
                },
                {
                    'Name': 'tag:Environment',
                    'Values': [
                        environment
                    ]
                },
                {
                    'Name': 'tag:Role',
                    'Values': [
                        ""
                    ]
                },
                {
                    'Name': 'availability-zone',
                    'Values': [
                        availability_zone
                    ]
                }
            ]
        )
    except Exception:
        print('Unable to search for EBS volumes. Cannot proceed. Exiting.')
        exit(1)

    try:
        volume_id = volumes['Volumes'][0]['VolumeId']

        print(volume_id + ' found.')
    except Exception:
        print('Could not find EBS volume. Cannot proceed. Exiting.')
        exit(1)
else:
    print('Not searching for volumes.')

try:
    print('Attaching volume ' + volume_id)
    response = ec2.attach_volume(
        Device='/dev/sdb',
        InstanceId=instance_id,
        VolumeId=volume_id
    )
    print('Attached volume ' + volume_id)
except Exception:
    print('Could not attach EBS volume.')
    exit(1)

try:
    print('Mounting volume ' + volume_id + ' ' + mount_point + '.')
    os.system('mount /dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_' + volume_id.replace('-', '') + ' ' + mount_point)
except Exception:
    print('Could not mount volume. Cannot proceed. Exiting.')
    exit(1)

print('Volume mount successfully completed. Exiting.')
exit(0)
