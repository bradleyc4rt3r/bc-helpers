#!/bin/python

import boto3

# Configs
environment = ""
r53_zone_id = ""
hosted_zone = ""
profile = ""
ttl = 300
hostname = ""

# Globals
aws_session = boto3.Session(profile_name=profile)
r53 = aws_session.client('route53')


def get_environment_records():
    print("Getting Existing Records")
    response = r53.list_resource_record_sets(
        HostedZoneId=r53_zone_id,
        StartRecordName=hostname + "." + hosted_zone,
        StartRecordType="A",
    )

    records = []
    for record in response['ResourceRecordSets']:
        if 'Name' in record and record['Name'] == hostname + "." + hosted_zone:
            records.append(record)
            continue
        else:
            break

    print("Found {count} records".format(count=len(records)))

    return records


def create_new_record(record):
    r53.change_resource_record_sets(
        HostedZoneId=r53_zone_id,
        ChangeBatch={
            'Changes': [
                {
                    'Action': "CREATE",
                    'ResourceRecordSet': {
                        'Name': "legacy." + environment + "." + hosted_zone,
                        'Type': "A",
                        'SetIdentifier': record['SetIdentifier'],
                        'Weight': record['Weight'],
                        'TTL': record['TTL'],
                        'ResourceRecords': record['ResourceRecords']
                    }
                },
            ]
        }
    )


def create_new_records(records):
    print("Creating New Records")
    for record in records:
        create_new_record(record)


def remove_existing_records(records):
    print("Removing Existing Records")
    payload = {
        'Changes': [
        ]
    }

    # Keeping first record to avoid downtime
    first = True
    for record in records:
        if first:
            first = False
            continue

        payload['Changes'].append(
            {
                'Action': "DELETE",
                'ResourceRecordSet': {
                    'Name': hostname + "." + hosted_zone,
                    'Type': "A",
                    'SetIdentifier': record['SetIdentifier'],
                    'Weight': record['Weight'],
                    'TTL': record['TTL'],
                    'ResourceRecords': record['ResourceRecords']
                }
            }
        )

    if payload['Changes']:
        r53.change_resource_record_sets(
            HostedZoneId=r53_zone_id,
            ChangeBatch=payload
        )


def migrate_main_record(records):
    print("Creating redirect record")

    record = records[0]
    r53.change_resource_record_sets(
        HostedZoneId=r53_zone_id,
        ChangeBatch={
            'Changes': [
                {
                    'Action': "DELETE",
                    'ResourceRecordSet': {
                        'Name': hostname + "." + hosted_zone,
                        'Type': "A",
                        'SetIdentifier': record['SetIdentifier'],
                        'Weight': record['Weight'],
                        'TTL': record['TTL'],
                        'ResourceRecords': record['ResourceRecords']
                    }
                },
                {
                    'Action': "CREATE",
                    'ResourceRecordSet': {
                        'Name': hostname + "." + hosted_zone,
                        'Type': "CNAME",
                        'SetIdentifier': 'legacy',
                        'Weight': 10,
                        'TTL': ttl,
                        'ResourceRecords': [
                            {
                                'Value': "legacy." + environment + "." + hosted_zone
                            }
                        ]
                    }
                }
            ]
        }
    )


def migrate_ec2_endpoints():
    records = get_environment_records()
    create_new_records(records)
    remove_existing_records(records)
    migrate_main_record(records)


migrate_ec2_endpoints()
