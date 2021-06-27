#####
# EFS Access Point
#####

##  EFS Access Point
resource "aws_efs_access_point" "eks_efs_access_point" {
  file_system_id = aws_efs_file_system.eks_efs.id

  posix_user {
    gid = "1000"
    uid = "1000"
  }

  root_directory {
    path = "/jenkins"

    creation_info {
      owner_gid   = "1000"
      owner_uid   = "1000"
      permissions = "777"
    }

  }

  tags = {
    Name        = "${var.project_prefix}-efs-access-point"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}
