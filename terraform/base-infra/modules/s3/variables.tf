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

# Account ID
variable "account_id" {
  description = "account_id"
}

##  VPC Variables
variable "vpc_id" {
  description = "The id of vpc"
}
