#!/usr/bin/python3

import boto3
import requests
import json
import logging


# Logging Setup
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

logger.info('BC EC2 R53 Boot Starting.')

try:
    logger.info('Fetching instance metadata...')
    availability_zone = requests.get('http://169.254.169.254/latest/meta-data/placement/availability-zone')
    availability_zone = availability_zone.text
    logger.info('Availability Zone: ' + availability_zone)

    region = availability_zone[:-1]
    logger.info('Region: ' + region)

    instance_id = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
    instance_id = instance_id.text
    logger.info('Instance ID: ' + instance_id)

    internal_ip = requests.get('http://169.254.169.254/latest/meta-data/local-ipv4')
    internal_ip = internal_ip.text
    logger.info('Internal IP: ' + internal_ip)

    try:
        public_ip = requests.get('http://169.254.169.254/latest/meta-data/public-ipv4')
        public_ip = public_ip.text
        logger.info('Public IP: ' + public_ip)
    except Exception:
        logger.info('Public IP not found, using internal_ip for public_ip.')
        public_ip = internal_ip
except Exception:
    logger.info('Could not fetch instance metadata. Cannot proceed. Exiting.', exc_info=True)
    exit(1)

try:
    logger.info('Creating boto3 route53 and ec2 client and resources...')
    ec2 = boto3.client('ec2', region_name=region)
    ec2_resource = boto3.resource('ec2', region_name=region)
    r53 = boto3.client('route53', region_name=region)
except Exception:
    logger.info('Failed to create boto3 clients. Cannot proceeed. Exiting.', exc_info=True)
    exit(1)

try:
    logger.info('Processing instance tags...')
    instance = ec2_resource.Instance(instance_id)
    for tag in instance.tags:
        logger.debug('Tag: ' + tag["Key"] + ': ' + tag["Value"])

        if tag["Key"] == "BCMeta":
            logger.info('BC metadata tag found.')
            meta = json.loads(tag["Value"])

            if isinstance(meta['ec2-r53-boot'], list):
                logger.info('List of records found.')
                records = meta['ec2-r53-boot']
            else:
                logger.info('Single record found.')
                records = [
                    meta['ec2-r53-boot']
                ]
except Exception:
    logger.error('Failed to process instance tags. Cannot proceed. Exiting.', exc_info=True)
    exit(1)

for record in records:
    try:
        r53_zone_id = record['zone_id']
        hostname = record['hostname']

        if 'public_ip' in record and record['public_ip']:
            ip = public_ip
        else:
            ip = internal_ip

        logger.info('Updating route53 zone ' + r53_zone_id + ' with ' + hostname + ' A ' + ip)

        r53.change_resource_record_sets(
            HostedZoneId=r53_zone_id,
            ChangeBatch={
                'Comment': 'Updated by bc-ec2-r53-boot',
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': hostname,
                            'Type': 'A',
                            'TTL': 30,
                            'ResourceRecords': [
                                {
                                    'Value': ip
                                }
                            ],
                        }
                    }
                ]
            }
        )
    except Exception:
        logger.error('Failed to update record. Will not proceed or retry. Exiting.', exc_info=True)
        exit(1)

logger.info('Route 53 Update Complete. Exiting.')
exit(0)
