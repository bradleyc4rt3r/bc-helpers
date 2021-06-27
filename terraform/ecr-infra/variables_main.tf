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
