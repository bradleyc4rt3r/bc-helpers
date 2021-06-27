#####
# EKS Node Group
#####
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project_prefix}-eks-node-group-v1"
  node_role_arn   = aws_iam_role.iam_role_eks_node.arn
  subnet_ids      = flatten([var.private_subnet])
  instance_types  = flatten([var.node_instance_type])
  capacity_type   = var.node_capacity_type

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  launch_template {
    id      = aws_launch_template.launch_template_eks_node.id
    version = aws_launch_template.launch_template_eks_node.latest_version
  }

  tags = {
    Name        = "${var.project_prefix}-eks-node-group-v1"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  # lifecycle {
  #   create_before_destroy = true
  #   # ignore_changes        = [scaling_config.0.desired_size]
  # }

}
