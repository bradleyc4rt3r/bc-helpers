##  Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}

variable "environment" {
  description = "Specify the environment"
}

variable "region" {
  description = "AWS region to deploy"
}

##  VPC Variables
variable "vpc_id" {
  description = "The id of vpc"
}

variable "pub_subnet_id" {
  description = "The id of public subnet"
}

## Grandcivitas Office Variables
variable "ssh_access_sg" {
  description = "AWS region to deploy"
}

## Bastion
variable "bastion_count" {
  description = "Flag to define the presence of bastion server"
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
