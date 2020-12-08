#!/bin/bash

echo "Testing AWS"
AWS_STATUS=$(curl -s -w '%{http_code}' http://169.254.169.254/latest/meta-data)
echo "Testing GCP"
GCP_STATUS=$(curl -s -w '%{http_code}' -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/)

MODULE_PATH=/opt/capsaas-toolbox/python/app
SCRIPT_PATH=/opt/capsaas-toolbox/python

if [[ "${AWS_STATUS: -3}" =~ ^2 ]];
then
  echo "AWS Environment recognised."
  PROVIDER=aws
elif [[ "${GCP_STATUS: -3}" =~ ^2 ]];
then
  echo "GCP Environment recognised."
  PROVIDER=gcp

  echo "Creating symlinks."
  ln -f /opt/toolbox/binaries/content /home/ur/bin/content
  ln -f /opt/toolbox/binaries/capture /home/ur/bin/capture
  ln -f /opt/toolbox/binaries/saas /home/ur/bin/saas

else
  echo "Environment not recognised."
  PROVIDER=
fi

if [[ ! -d $MODULE_PATH ]]; then
  echo "Creating directory $MODULE_PATH"
  mkdir $MODULE_PATH
fi

for SOURCE_PATH in common $PROVIDER;
do
  echo "Moving modules from $SOURCE_PATH to $MODULE_PATH"
  cp /opt/toolbox/python/.code/${SOURCE_PATH}/modules/ur_* ${MODULE_PATH}/.

  echo "Moving scripts from $SOURCE_PATH to $SCRIPT_PATH"
  cp /opt/toolbox/python/.code/${SOURCE_PATH}/scripts/ur-* ${SCRIPT_PATH}/.

  echo "Installing requirements"
  pip3.6 install -r /opt/toolbox/python/.code/${SOURCE_PATH}/requirements.txt
done

echo "boot.sh finished"

