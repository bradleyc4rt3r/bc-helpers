output "efs_access_point_id" {
  value = aws_efs_access_point.eks_efs_access_point.id
}

output "efs_file_system_id" {
  value = aws_efs_file_system.eks_efs.id
}
