# Common Variables
variable "region" {
  description = "AWS region to deploy"
}

variable "environment" {
  description = "Specify the environment - dev/stg/prod"
}

variable "project" {
  description = "Specify the project name"
}

# Assume Role Variables
variable "account_id" {
  description = "The account id that will be accessed"
}

variable "assume_role" {
  description = "The role that will be assumed into"
}
variable "external_id" {
  description = "The custom verification id for the assumed role"
}

# ALB
variable "alb_health_check_path" {
  description = "health check path"
}

variable "alb_health_status_code" {
  description = "alb health status code"
}

## EC2 - artifactory - Launch
variable "ec2_artifactory_instance_type" {
  description = "ec2_artifactory_instance_type"
}

variable "ec2_artifactory_launch_version" {
  description = "ec2_artifactory_launch_version"
}


## EC2 - artifactory - Auto Scaling Group
variable "ec2_artifactory_min_count" {
  description = "ec2_artifactory_min_count"
}

variable "ec2_artifactory_desired_count" {
  description = "ec2_artifactory_desired_count"
}

variable "ec2_artifactory_max_count" {
  description = "ec2_artifactory_max_count"
}

## WireGuard VPC Variables
variable "wireguard_vpc_cidr_dev" {
  description = "The CIDR block for the WireGuard dev vpc"
}

variable "wireguard_vpc_cidr_prd" {
  description = "The CIDR block for the WireGuard prd vpc"
}

### Jenkins VPC Access
variable "jenkins_vpc_cidr" {
  description = "The CIDR block for the Jenkins vpc"
}

 # ACM
 variable "domain_name" {
  description = "domain_name"
}
