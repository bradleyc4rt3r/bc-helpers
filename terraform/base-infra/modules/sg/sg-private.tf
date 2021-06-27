#####
# Security Groups
#####

##  Security Group for private
resource "aws_security_group" "private" {
  name        = "${var.project_prefix}-sg-private"
  description = "Private access within VPC"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_prefix}-sg-private"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

  lifecycle {
    ignore_changes = [
      ingress,
    ]
  }

}

# Local VPC Rules
resource "aws_security_group_rule" "local_vpc" {
  security_group_id = aws_security_group.private.id
  cidr_blocks       = [var.vpc_cidr]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "Full access within VPC"
}

# WireGuard Rules
resource "aws_security_group_rule" "wireguard_dev" {
  count             = var.environment == "prd" ? 0 : 1
  security_group_id = aws_security_group.private.id
  cidr_blocks       = [var.wireguard_vpc_cidr_dev]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - Dev"
}

resource "aws_security_group_rule" "wireguard_prd" {
  security_group_id = aws_security_group.private.id
  cidr_blocks       = [var.wireguard_vpc_cidr_prd]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - PRD"
}
