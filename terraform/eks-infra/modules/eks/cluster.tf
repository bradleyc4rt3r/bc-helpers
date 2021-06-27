#####
# EKS Cluster
#####
resource "aws_eks_cluster" "cluster" {
  name                      = "${var.project_prefix}-eks-cluster-v1"
  role_arn                  = aws_iam_role.iam_role_eks_cluster.arn
  version                   = var.node_kubernetes_version
  enabled_cluster_log_types = []

  depends_on = [aws_cloudwatch_log_group.eks_cluster_log_group]

  vpc_config {
    subnet_ids         = flatten([var.private_subnet, var.public_subnet])
    security_group_ids = flatten([var.private_security_group])

    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  tags = {
    Name        = "${var.project_prefix}-eks-cluster-v1"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name              = "/aws/eks/${var.project_prefix}-eks-cluster-v1/cluster"
  retention_in_days = 7

  tags = {
    project_prefix = var.project_prefix
    environment    = var.environment
    CreatedBy      = "Terraform"
  }
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
