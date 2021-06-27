#### -------------------------------

output "region" {
  value = "\"${var.region}\""
}
output "environment" {
  value = "\"${var.environment}\""
}
output "project" {
  value = "\"${var.project}\""
}

# EKS
output "eks-cluster-name" {
  value = module.eks.eks_cluster_name
}

# EFS
output "efs_file_system_id" {
  value = module.efs.efs_file_system_id
}

