#!/usr/bin/python3

import boto3
import requests
import json


print('BC Elastic IP Address Service.')
attached = False

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
except Exception:
    print('Could not fetch instance metadata. Cannot proceed. Exiting.')
    exit(1)

try:
    print('Creating boto3 ec2 client and resource...')
    ec2 = boto3.client('ec2', region_name=region)
    ec2_resource = boto3.resource('ec2', region_name=region)
except Exception:
    print('Failed to create boto3 clients. Cannot proceeed. Exiting.')
    exit(1)

try:
    print('Processing instance tags...')
    instance = ec2_resource.Instance(instance_id)
    for tag in instance.tags:
        print('Tag: ' + tag["Key"] + ': ' + tag["Value"])

        if tag["Key"] == "BCMeta":
            print('BC metadata tag found.')
            meta = json.loads(tag["Value"])
            eip_id = meta['eip-attach']['eip_id']
            print('EIP ' + eip_id + ' found in metadata.')
except Exception:
    print('Failed to process instance tags. Cannot proceed. Exiting.')
    exit(1)

try:
    print('Fetching EIP details for ' + eip_id)
    response = ec2.describe_addresses(
        AllocationIds=[
            eip_id
        ]
    )
    if 'InstanceId' not in response['Addresses'][0]:
        eip_instance_id = ''
    else:
        eip_instance_id = response['Addresses'][0]['InstanceId']

    if eip_instance_id == '':
        print('EIP not attached to instance.')
        attached = False
    elif eip_instance_id != instance_id:
        print('EIP currently attached to ' + eip_instance_id)
        attached = False
    else:
        print('EIP already attached.')
        attached = True
except Exception:
    print('An error occurred while fetching EIP details. Cannot proceed. Exiting.')
    exit(1)

if not attached:
    print('Attaching EIP ' + eip_id + ' to ' + instance_id)
    ec2.associate_address(
        AllocationId=eip_id,
        InstanceId=instance_id,
        AllowReassociation=True
    )

print('EIP attachment successfully completed. Exiting.')
exit(0)
