#! /bin/bash

# User Data Logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Change SSH Port
echo "Port ${bastion_ssh_port}" >> /etc/ssh/sshd_config
service sshd restart

# Change Hostname
hostnamectl set-hostname ${project_prefix}-bastion
echo "127.0.0.1 ${project_prefix}-bastion" >> /etc/hosts

#  Update & Install Packages
apt update
apt install -y telnet tree vim unzip net-tools awscli ansible git zip wget curl

# Adding a developer user
useradd -m -s /bin/bash developer 
mkdir -p /home/developer/.ssh/
echo "${ec2_kp_developer_pub_key}" > /home/developer/.ssh/authorized_keys
chown -R developer:developer /home/developer/.ssh/
chmod 600 /home/developer/.ssh/authorized_keys
chmod 700 /home/developer/.ssh/

# Warning
echo 'echo " ██╗    ██╗ █████╗ ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗ ██╗  "'     >> /usr/local/share/warningrc
echo 'echo " ██║    ██║██╔══██╗██╔══██╗████╗  ██║██║████╗  ██║██╔════╝ ██║  "'     >> /usr/local/share/warningrc
echo 'echo " ██║ █╗ ██║███████║██████╔╝██╔██╗ ██║██║██╔██╗ ██║██║  ███╗██║  "'     >> /usr/local/share/warningrc
echo 'echo " ██║███╗██║██╔══██║██╔══██╗██║╚██╗██║██║██║╚██╗██║██║   ██║╚═╝  "'     >> /usr/local/share/warningrc
echo 'echo " ╚███╔███╔╝██║  ██║██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝██╗  "'     >> /usr/local/share/warningrc
echo 'echo "  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  "'     >> /usr/local/share/warningrc
echo 'echo " "'                                                                    >> /usr/local/share/warningrc
echo 'echo "If you are not a authorized personal, Please exit this terminal now!"' >> /usr/local/share/warningrc
echo 'echo "           All Actions are tracked and recorded!"'                     >> /usr/local/share/warningrc

echo "source /usr/local/share/warningrc" >> /home/ubuntu/.bashrc
echo "source /usr/local/share/warningrc" >> /home/developer/.bashrc

# Set timezone to BST
unlink /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
date

# Install glusterfs
apt-get -y install software-properties-common
echo | add-apt-repository ppa:gluster/glusterfs-7
echo | apt install glusterfs-server

# Install AWS inspector-agent
wget https://inspector-agent.amazonaws.com/linux/latest/install
bash install

# MongoDB client
apt install -y mongodb-clients

# MariaDB
apt install -y mariadb-server
systemctl enable mariadb

# Final OS Upgrade
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
DEBIAN_FRONTEND=noninteractive apt -y install linux-aws 
DEBIAN_FRONTEND=noninteractive apt -y  dist-upgrade 
apt update 
apt -y autoremove

