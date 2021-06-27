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

# EKS
variable "eks_node_instance_type" {
  description = "eks instance type"
}

variable "eks_node_disk_size" {
  description = "eks_node_disk_size"
}

variable "eks_node_capacity_type" {
  description = "eks capacity type"
}

variable "eks_node_kubernetes_version" {
  description = "eks_node_kubernetes_version"
}

variable "eks_node_desired_size" {
  description = "eks_node_desired_size"
}

variable "eks_node_max_size" {
  description = "eks_node_max_size"
}

variable "eks_node_min_size" {
  description = "eks_node_min_size"
}
