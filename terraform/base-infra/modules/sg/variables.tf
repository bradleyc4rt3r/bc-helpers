##  Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}

variable "environment" {
  description = "Specify the environment"
}

##  VPC Variables
variable "vpc_id" {
  description = "The id of vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the vpc"
}

## Bastion Variables
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
