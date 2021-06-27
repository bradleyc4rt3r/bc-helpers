#!/bin/bash
###############################################################################
# Startup sript for artifactory.
# Create by: Vimal CS
# Date : 17 May 2021
###############################################################################
# enable bash strict mode
set -euo pipefail
IFS=$'\n\t'

###############################################################################
# Echo all parameters to the log file.
#==============================================================================
# $@ = log message(s)
#------------------------------------------------------------------------------
# $? = 0 if successful
###############################################################################
function log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S")" "$@"
}

###############################################################################
# User Data Logs
###############################################################################
function user_data() {
    log "User Data Logs"
    exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
}

###############################################################################
# Change Hostname
###############################################################################
function hostname() {
    log "Change Hostname"

    hostnamectl set-hostname ${project-prefix }-artifactory
    echo "127.0.0.1 ${project-prefix }-artifactory" >>/etc/hosts
}

###############################################################################
#  Update & Install basic Packages
###############################################################################
function basic_packages() {
    log "Install basic Packages"
    apt update
    apt install -y telnet tree vim unzip net-tools awscli ansible git zip wget curl
}

###############################################################################
# Set timezone
###############################################################################
function timezone() {
    log "Set timezone"
    unlink /etc/localtime
    ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
}

###############################################################################
# Install AWS inspector-agent
###############################################################################
function inspector_agent() {
    log "Install AWS inspector-agent"
    wget https://inspector-agent.amazonaws.com/linux/latest/install
    bash install
}

###############################################################################
#  Mount EBS
###############################################################################
function mount_ebs() {
    log "Mount EBS"

    mkdir -p /opt/jfrog/
    mkfs -t xfs /dev/nvme1n1
    MT_POINT=$(cat /etc/fstab | grep -w "/dev/nvme1n1" || true)
    if [ -z "$MT_POINT" ]; then
        echo "/dev/nvme1n1  /opt/jfrog/  xfs  defaults   0 0" >>/etc/fstab
    else
        echo "Mount Point already exist"
    fi
    mount -a

}

###############################################################################
#  Instal JFrog Artifactory OSS
###############################################################################
function install_jfrog_oss() {
    log "Instal JFrog Artifactory OSS"

    apt install -y openjdk-11-jdk openjdk-11-doc
    apt install -y wget software-properties-common
    wget -qO - https://api.bintray.com/orgs/jfrog/keys/gpg/public.key | apt-key add -
    add-apt-repository "deb [arch=amd64] https://jfrog.bintray.com/artifactory-debs $(lsb_release -cs) main"

    apt update
    apt install -y jfrog-artifactory-oss

    systemctl start artifactory.service
    systemctl enable artifactory.service

}

###############################################################################
# Configure Jfrog Artifactory
###############################################################################
function configure_jfrog() {

    CHECK_BUCKET=$(aws s3 ls s3://${artifactory-bucket}/artifactory/ || true)
    if [ -z "$CHECK_BUCKET" ]; then
        log "Fresh Installation. Skip copying Jfrog Artifactory files from S3 Bucket"
    else
        log "Copy Jfrog Artifactory files"

        systemctl stop artifactory.service
        sleep 30

        JFROG_HOME="/opt/jfrog"
        JFROG_VAR="/var/opt/jfrog/artifactory"
        rm -rf $JFROG_HOME/* || true
        rm -rf $JFROG_VAR/* || true
        mkdir -p $JFROG_HOME/artifactory/app
        mkdir -p $JFROG_VAR
        aws s3 sync s3://${artifactory-bucket}/ $JFROG_HOME/ --exclude "artifactory/var/*" --delete --exact-timestamps
        aws s3 sync s3://${artifactory-bucket}/artifactory/var/ $JFROG_VAR/ --delete --exact-timestamps

        cd $JFROG_HOME/artifactory/ && ln -nfs $JFROG_VAR var
        chown artifactory.artifactory $JFROG_HOME -R
        chown artifactory.artifactory $JFROG_VAR -R
        find $JFROG_HOME/ -type f -iname "*.sh" -exec chmod +x {} \;
        find $JFROG_HOME/artifactory/app/bin/ -type f -exec chmod +x {} \;
        chmod 755 $JFROG_HOME/ -R

        systemctl start artifactory.service
        sleep 30
        systemctl enable artifactory.service
        systemctl daemon-reload
        systemctl status artifactory.service

    fi

}

###############################################################################
# Configure S3 Sync
###############################################################################
function s3_sync() {

    s3_sync_script="$(
        cat <<EOF
#!/bin/bash -ex
aws s3 sync /opt/jfrog/ s3://${artifactory-bucket}/ --exact-timestamps
find /home/ubuntu/shellscripts/ -type f -name '*.log' -size +20M -exec zip -r s3_sync.log-$(date '+%Y%m%d-%H%M').zip s3_sync.log {} \;
find /home/ubuntu/shellscripts/ -type f -name '*.zip' -mtime +30 -exec rm -rf {} \;

EOF
    )"

    log "Configure S3 Sync"
    mkdir -p /home/ubuntu/shellscripts
    echo "$s3_sync_script" >/home/ubuntu/shellscripts/s3_sync_script.sh
    sudo chmod +x /home/ubuntu/shellscripts/s3_sync_script.sh

    crontab -r || true
    echo "*/2 * * * *  /home/ubuntu/shellscripts/s3_sync_script.sh > /home/ubuntu/shellscripts/s3_sync.log 2>&1" >jobs.txt
    crontab jobs.txt
}

###############################################################################
#  Configure Nginx Reverse Proxy
###############################################################################
function nginx_proxy() {
    log "Configure Nginx Reverse Proxy"

    apt install -y nginx

    nginx_proxy_config="$(
        cat <<EOF
## server configuration
server {
    listen 80 ;
      
    server_name artifactory.${domain-name};
 
    if (\$http_x_forwarded_proto = '') {
        set \$http_x_forwarded_proto  \$scheme;
    }
    ## Application specific logs
    access_log /var/log/nginx/artifactory.ops.sasyadev.com-access.log;
    error_log /var/log/nginx/artifactory.ops.sasyadev.com-error.log;
    rewrite ^/\$ /ui/ redirect;
    rewrite ^/ui\$ /ui/ redirect;
    chunked_transfer_encoding on;
    client_max_body_size 0;
    location / {
        proxy_read_timeout  2400s;
        proxy_pass_header   Server;
        proxy_cookie_path   ~*^/.* /;
        proxy_pass          http://127.0.0.1:8082;
        proxy_next_upstream error timeout non_idempotent;
        proxy_next_upstream_tries    1;
        proxy_set_header    X-JFrog-Override-Base-Url \$http_x_forwarded_proto://\$host:443;
        proxy_set_header    X-Forwarded-Port  443;
        proxy_set_header    X-Forwarded-Proto \$http_x_forwarded_proto;
        proxy_set_header    Host              \$http_host;
        proxy_set_header    X-Forwarded-For   \$proxy_add_x_forwarded_for;
 
        location ~ ^/artifactory/ {
            proxy_pass    http://127.0.0.1:8081;
        }
    }
}

EOF
    )"

    echo "$nginx_proxy_config" >/etc/nginx/sites-available/artifactory.conf
    ln -s /etc/nginx/sites-available/artifactory.conf /etc/nginx/sites-enabled/
    systemctl restart nginx

}

###############################################################################
# Final OS Upgrade
###############################################################################
function os_upgrade() {
    log "Final OS Upgrade"

    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
    DEBIAN_FRONTEND=noninteractive apt -y install linux-aws
    DEBIAN_FRONTEND=noninteractive apt -y dist-upgrade
    apt update
    apt -y autoremove
}

###############################################################################
# Main Function
###############################################################################
function main() {
    user_data
    hostname
    basic_packages
    timezone
    inspector_agent
    mount_ebs
    install_jfrog_oss
    configure_jfrog
    s3_sync
    nginx_proxy
    os_upgrade
}

# Call Main
main
