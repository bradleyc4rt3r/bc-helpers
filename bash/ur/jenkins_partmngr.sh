#!/bin/bash
set -x

# Determine IDs
ids_installation=()
ids_directory=()
len=${#ids_installation[@]}


#add loop over install id's

for ((ids=0;ids<$len;++ids)); do
  # Obtain project information from restAuth
  DETAILS=$(mysql -u${RESTAUTH_USER_EU} -p${RESTAUTH_PASSWORD_EU} restAuth -A -sN -h${RESTAUTH_HOST_EU} -e "select dbHost,dbPort,dbName,dbUser,dbPassword,dbWebUserRO, dbWebPasswordRO, versionCapture from installation where installationId=${ids_installation[$ids]};" | tr -s '\t' | tr '\t' ',')
  dbHost=$(echo $DETAILS |cut -d"," -f1)
  dbPort=$(echo $DETAILS |cut -d"," -f2)
  dbName=$(echo $DETAILS |cut -d"," -f3)
  dbUser=$(echo $DETAILS |cut -d"," -f4)
  dbPasswd=$(echo $DETAILS |cut -d"," -f5)
  dbUserRO=$(echo $DETAILS | cut -d"," -f6)
  dbPasswdRO=$(echo $DETAILS | cut -d"," -f7)
  version=$(echo $DETAILS |cut -d"," -f8 |cut -d'.' -f1-2)
  
  # Copy correct binaries from /home/ur to suit the installation
  mkdir -p ${WORKSPACE}/partmngr/htdocs/cron
  cp -R /var/lib/jenkins/ur/${version}/partmngr/htdocs/cron/* ${WORKSPACE}/partmngr/htdocs/cron
  
  # Create
  mkdir -p ${WORKSPACE}/${ids_directory[$ids]}/assets
  
  config_file=${WORKSPACE}/${ids_directory[$ids]} assets/partmngr.ph
p  cat > ${config_file} <<EOL
<?php

define('UR_PARTITION_MANAGER', true);

############################################
# DATABASE
############################################
define('UR_CONFIG_DBSERVER', '${dbHost}');
define('UR_DB_PORT', ${dbPort});
define('UR_CONFIG_DBNAME', '${dbName}');
define('UR_CONFIG_DBUSER', '${dbUser}');
define('UR_CONFIG_DBPW', '${dbPasswd}');
define('UR_CONFIG_DBUSERRO', '${dbUserRO}');
define('UR_CONFIG_DBPWRO', '${dbPasswdRO}');
define('UR_ENCRYPTED', 'true');
define('UR_ENCRYPTION_KEY', 'v7.4');
EOL


  php ${WORKSPACE}/partmngr/htdocs/cron/partmngr.php saas 0 ${ids_installation[$ids]}
  sleep 10
done
set +x
