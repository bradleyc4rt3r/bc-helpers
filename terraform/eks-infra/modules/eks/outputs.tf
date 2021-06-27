output "eks_cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}
