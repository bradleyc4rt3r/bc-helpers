#####
# EFS Mount Target
#####

##  EFS Mount Target
resource "aws_efs_mount_target" "eks_efs_mount_target" {
count                   = length(var.private_subnet)
  file_system_id  = aws_efs_file_system.eks_efs.id
  subnet_id       = var.private_subnet[count.index]
  security_groups = flatten([var.private_security_group])

}
