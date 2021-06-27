#####
# Security Group
#####

##  Security Group for artifactory
resource "aws_security_group" "ec2_artifactory" {
  name        = "${var.project_prefix}-sg-artifactory"
  description = "Artifactory access within VPC"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Access to external network"
  }

  tags = {
    Name        = "${var.project_prefix}-sg-artifactory"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Full access within VPC 
resource "aws_security_group_rule" "artifactory_web" {
  security_group_id = aws_security_group.ec2_artifactory.id
  cidr_blocks       = [var.vpc_cidr]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "Full access within VPC"
}

# WireGuard Rules
resource "aws_security_group_rule" "wireguard_dev" {
  security_group_id = aws_security_group.ec2_artifactory.id
  cidr_blocks       = [var.wireguard_vpc_cidr_dev]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - Dev"
}

resource "aws_security_group_rule" "wireguard_prd" {
  security_group_id = aws_security_group.ec2_artifactory.id
  cidr_blocks       = [var.wireguard_vpc_cidr_prd]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - PRD"
}

# Jenkins Rules
resource "aws_security_group_rule" "jenkins" {
  security_group_id = aws_security_group.ec2_artifactory.id
  cidr_blocks       = [var.jenkins_vpc_cidr]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "Jenkins VPC access"
}

