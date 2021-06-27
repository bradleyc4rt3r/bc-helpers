#####
# VPC 
#####

data "aws_availability_zones" "available" {
  state = "available"
}

## VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_prefix}-vpc"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}
