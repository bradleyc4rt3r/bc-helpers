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

variable "account_id" {
  description = "Specify account_id"
}

variable "vpc_id" {
  description = "VPC id of the infra"
}

variable "alb_security_gp" {
  description = "comma seperated list of security groups for alb "
  type        = list(string)
}

variable "alb_subnet_list" {
  description = "comma seperated list of subnets for alb "
  type        = list(string)
}

variable "alb_health_check_path" {
  description = "health check path"
}

variable "alb_health_status_code" {
  description = "alb health status code"
}

 # ACM
 variable "domain_name" {
  description = "domain_name"
}
