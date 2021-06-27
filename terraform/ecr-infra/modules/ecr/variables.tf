# Common Variables
variable "environment" {
  description = "Specify the project environment"
}

variable "region" {
  description = "AWS region to deploy"
}

variable "project_prefix" {
  description = "Specify the project name "
}

# ECR Variables
variable "ecr_name" {
  description = "ECR Repo name"
}