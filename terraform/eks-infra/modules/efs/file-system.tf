#####
# EFS File System
#####

##  EFS File System
resource "aws_efs_file_system" "eks_efs" {
  creation_token   = "${var.project_prefix}-efs-token"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name        = "${var.project_prefix}-efs-v1"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}
