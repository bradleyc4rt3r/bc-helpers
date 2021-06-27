##  Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}

variable "region" {
  description = "AWS region to deploy"
}

variable "environment" {
  description = "Specify the project environment"
}

##  VPC Variables
variable "vpc_id" {
  description = "The id of vpc"
}

variable "vpc_cidr" {
  description = "vpc_cidr"
}

## EC2 - artifactory - Launch
variable "ec2_artifactory_instance_type" {
  description = "ec2_artifactory instance type"
}

variable "ec2_artifactory_security_group" {
  description = "ec2_artifactory_security_group"
}

variable "ec2_subnets" {
  description = "ec2_subnets"
}

variable "ec2_artifactory_key_name" {
  description = "ec2_artifactory_key_name"
}


variable "ec2_artifactory_launch_version" {
  description = "ec2_artifactory_launch_version"
}

variable "artifactory_bucket" {
  description = "artifactory_bucket"
}

 variable "domain_name" {
  description = "domain_name"
}


## EC2 - artifactory - Auto Scaling Group
variable "target_group_arn" {
  description = "target_group_arn"
}

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
