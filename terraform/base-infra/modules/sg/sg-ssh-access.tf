#####
# Security Groups
#####

##  Security Group for SSH access
resource "aws_security_group" "ssh_access" {
  name        = "${var.project_prefix}-sg-ssh-access"
  description = "SSH access to Bastion instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_prefix}-sg-ssh-access"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}


# Local VPC Rules
resource "aws_security_group_rule" "local_vpc" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_blocks       = ["117.193.45.71/32", "117.193.42.62/32"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.bastion_ssh_port
  to_port           = var.bastion_ssh_port
  description       = "SSH access to Bastion instance"
}

# WireGuard Rules
resource "aws_security_group_rule" "wireguard_dev" {
  count             = var.environment == "gbl" ? 0 : 1
  security_group_id = aws_security_group.ssh_access.id
  cidr_blocks       = [var.wireguard_vpc_cidr_dev]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - Dev"
}

resource "aws_security_group_rule" "wireguard_prd" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_blocks       = [var.wireguard_vpc_cidr_prd]
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  description       = "WireGuard VPC access - PRD"
}
