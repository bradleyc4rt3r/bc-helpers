# ### Common variables
region      = "east-1" /* AWS region to deploy  */
environment = "" /* Specify the environment as 3 letter code - dev/stg/prd/tst/emg */
project     = "" /* Project name for which infra is built */ #

# Assume Role Variables
account_id  = ""
assume_role = ""
external_id = ""

### VPC Variables
vpc_cidr            = "10.1.0.0/16"                     #VPC CIDR
nat_count           = "1"                                # Count of NAT gateways
private_subnet_cidr = ["10.1.8.0/24", "10.1.16.0/24"]  # CIDR blocks for the private subnets
public_subnet_cidr  = ["10.1.24.0/24", "10.1.32.0/24"] # CIDR blocks for the public subnets

### EC2-Bastion Variables
enable_bastion           = true
bastion_ssh_port         = 121
bastion_instance_type    = "t2.micro"
ec2_kp_sudo_pub_key      = ""
ec2_kp_developer_pub_key = ""

### WireGuard VPN Variables
wireguard_vpc_cidr_dev = "10.1.0.0/16" 
wireguard_vpc_cidr_prd = "10.2.0.0/16" 

