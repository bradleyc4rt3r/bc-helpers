# Common Variables
variable "project_prefix" {
  description = "Specify the project_prefix"
}
variable "environment" {
  description = "Specify the environment"
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

# S3 Bukcet- Infra Logs
variable "s3_logging_arn" {
  description = "s3_logging_arn"
}
