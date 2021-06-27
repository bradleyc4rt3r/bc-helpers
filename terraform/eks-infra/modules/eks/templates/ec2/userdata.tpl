MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -ex

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

/etc/eks/bootstrap.sh ${CLUSTER_NAME} --b64-cluster-ca ${B64_CLUSTER_CA} --apiserver-endpoint ${API_SERVER_URL}

# Change Hostname
hostnamectl set-hostname ${project_prefix}-eks-node
echo "127.0.0.1 ${project_prefix}-eks-node" >> /etc/hosts


apt-get update;
apt-get -y install software-properties-common
echo | add-apt-repository ppa:gluster/glusterfs-7

echo | apt install glusterfs-server

DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
DEBIAN_FRONTEND=noninteractive apt -y install linux-aws 
DEBIAN_FRONTEND=noninteractive apt -y  dist-upgrade 
apt update 
apt -y autoremove

wget https://inspector-agent.amazonaws.com/linux/latest/install
bash install
--==MYBOUNDARY==--\