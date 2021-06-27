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

variable "region" {
  description = "Specify the region"
}


# Account ID
variable "account_id" {
  description = "account_id"
}

# VPC Variables
variable "vpc_id" {
  description = "VPC id of the infra"
}

# EKS
variable "cluster_id" {
  description = "cluster_id"
}

variable "cluster_name" {
  description = "cluster_name"
}

