#####
# Security Group
#####

##  Security Group for efs
resource "aws_security_group" "efs" {
  name        = "${var.project_prefix}-sg-efs"
  description = "Amazon EFS for EKS, SG for mount target"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_prefix}-sg-efs"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}




