# ### Common variables
region      = "us-east-1" /* AWS region to deploy  */
environment = "dev" /* Specify the environment as 3 letter code - dev/stg/prd/tst/emg */
project     = "devops" /* Project name for which infra is built */ #

# Assume Role Variables
account_id  = "788814869451"
assume_role = "devops-dev-account-admin-access-role"
external_id = "ARDEMeDFmluWn"

#ALB Vars
alb_health_check_path  = "/"
alb_health_status_code = "200"

# EC2
ec2_artifactory_instance_type  = "m5.large"
ec2_artifactory_launch_version = "v19"
ec2_artifactory_min_count      = "1"
ec2_artifactory_desired_count  = "1"
ec2_artifactory_max_count      = "1"

### WireGuard VPN Variables
wireguard_vpc_cidr_dev = "10.1.0.0/16"
wireguard_vpc_cidr_prd = "10.2.0.0/16"

### Jenkins VPC Variables
jenkins_vpc_cidr = "10.21.0.0/16" 

# ACM Variables
domain_name  = "ops.sasyadev.com"