#!/usr/bin/python3

import boto3
import requests
import json
import logging
import os


# Logging Setup
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

logger.info('BC Local Storage Starting.')

logger.info('Creating /mnt/local directory')
os.system('mkdir -p /mnt/local')

logger.info('Formatting /dev/nvme1n1 with XFS')
os.system('mkfs.xfs /dev/nvme1n1')

logger.info('Mounting /dev/nvme1n1')
os.system('mount /dev/nvme1n1 /mnt/local')


logger.info('Local Storage Service Complete. Exiting.')
exit(0)
