# Account
data "aws_caller_identity" "current" {}

# VPC
data "aws_vpc" "main" {
  tags = {
    Name        = "${local.project_prefix}-vpc"
    environment = var.environment
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name        = "${local.project_prefix}-private-*"
    environment = var.environment
  }
}

data "aws_subnet" "private" {
  count = length(data.aws_subnet_ids.private.ids)
  id    = tolist(data.aws_subnet_ids.private.ids)[count.index]
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name        = "${local.project_prefix}-public-*"
    environment = var.environment
  }
}

data "aws_subnet" "public" {
  count = length(data.aws_subnet_ids.public.ids)
  id    = tolist(data.aws_subnet_ids.public.ids)[count.index]
}

# Security Group
data "aws_security_group" "private" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["${local.project_prefix}-sg-private"]
  }
}


data "aws_security_group" "loabbalancer" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["${local.project_prefix}-sg-alb"]
  }
}
