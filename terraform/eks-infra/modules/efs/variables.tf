##  Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}

variable "environment" {
  description = "Specify the environment - dev/stg/prod"
}

##  VPC Variables
variable "vpc_id" {
  description = "The id of vpc"
}

variable "vpc_cidr" {
  description = "vpc_cidr"
}


variable "private_subnet" {
  description = "private_subnets_list"
  type        = list(string)
}

# Security Group
variable "private_security_group" {
  description = "Security Group id of the private"
}

