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

# VPC Variables
variable "vpc_cidr" {
  description = "The CIDR block for the vpc"
}

variable "nat_count" {
  description = "Number of NAT gateways to be deployed"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "The CIDR blocks for the public subnets"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "The CIDR blocks for the private subnets"
}

## Bastion
variable "enable_bastion" {
  description = "Flag to define the presence of bastion server"
  type        = bool
}

variable "bastion_instance_type" {
  description = "bastion instance type"
}

variable "ec2_kp_sudo_pub_key" {
  description = "public key of ec2 kp for sudo user"
}

variable "ec2_kp_developer_pub_key" {
  description = "public key of ec2 kp for developer user"
}

variable "bastion_ssh_port" {
  description = "port where ssh service should run"
}


## WireGuard VPC Variables
variable "wireguard_vpc_cidr_dev" {
  description = "The CIDR block for the WireGuard dev vpc"
}

variable "wireguard_vpc_cidr_prd" {
  description = "The CIDR block for the WireGuard prd vpc"
}
