# Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}

variable "project" {
  description = "Specify the project name"
}

variable "environment" {
  description = "Specify the environment - dev/stg/prod"
}

# VPC Variables
variable "vpc_id" {
  description = "VPC id of the infra"
}

variable "public_subnet" {
  description = "comma seperated list of public subnets for  "
  type        = list(string)
}

variable "private_subnet" {
  description = "private_subnets_list"
  type        = list(string)
}

# Security Group
variable "private_security_group" {
  description = "Security Group id of the private"
}


# Node
variable "key_pair" {
  description = "eks key_pair"
}

variable "ubuntu_ami" {
  description = "ubuntu_ami"
}

variable "node_instance_type" {
  description = "eks node instance type"
}

variable "node_disk_size" {
  description = "node_disk_size"
}

variable "node_capacity_type" {
  description = "node_capacity_type"
}

variable "node_kubernetes_version" {
  description = "node_kubernetes_version"
}

variable "node_desired_size" {
  description = "node_desired_size"
}

variable "node_max_size" {
  description = "node_max_size"
}

variable "node_min_size" {
  description = "node_min_size"
}
