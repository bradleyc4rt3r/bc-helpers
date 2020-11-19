#!/usr/bin/python3

import boto3
import requests
import os
import json
from time import sleep


print('BC Repo Clone Boot Starting.')

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
    print(str(e))
    exit(1)

try:
    print('Creating boto3 ssm and ec2 client and resources...')
    ec2_resource = boto3.resource('ec2', region_name=region)
    ssm = boto3.client('ssm', region_name=region)
except Exception as e:
    print('Failed to create boto3 clients. Cannot proceed. Exiting.')
    print(str(e))
    exit(1)

try:
    print('Processing instance tags...')
    instance = ec2_resource.Instance(instance_id)

    for tag in instance.tags:
        print('Tag: ' + tag["Key"] + ': ' + tag["Value"])

        if tag['Key'] == 'aws:autoscaling:groupName':
            group_name = tag["Value"]

except Exception as e:
    print('Failed to describe instance tags. Cannot Proceed. Exiting')
    print(str(e))
    exit(1)

if group_name:
    print('ASG Group Name: ' + group_name)
else:
    print('Failed to get instance metadata. Cannot proceed. Exiting.')
    exit(1)

try:
    print('Retrieving Parameter: ' + group_name + '-repo-clone-boot')
    parameter = ssm.get_parameter(Name=group_name + '-repo-clone-boot')
    repositories = json.loads(parameter['Parameter']['Value'])

except Exception as e:
    print('Failed to Get Parameters. Cannot Proceed. Exiting.')
    print(str(e))
    exit(1)

print(str(repositories))

if 'repositories' in repositories:
    for repo in repositories['repositories']:
        print('processing repo ' + repo['url'])

        try:
            if os.path.exists(repo['path']):
                print('Repository already present on device, updating...')
                os.system('rm -rf ' + repo['path'])

            print('Branch: ' + repo['branch'])
            os.system('git clone -b ' + repo['branch'] + ' ' + repo['url'] + ' ' + repo['path'])

            while not os.path.exists(repo['path']):
                print('Waiting to clone repository...')
                sleep(1)

            print('Successfully cloned repository: ' + repo['url'])

        except Exception as e:
            print('Failed to clone repo: ' + repo['url'] + ' Exiting.')
            print(str(e))
            exit(1)
else:
    print('No repositories found.')

print('bc-repo-clone-boot has finished. ')
