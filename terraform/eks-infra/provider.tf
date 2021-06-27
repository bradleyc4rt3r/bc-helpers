## terraform
provider "aws" {
  region  = var.region
  profile = "${var.project}-${var.environment}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
    session_name = "terraform-assume-role"
    external_id  = var.external_id
  }

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

## kubernetes
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #load_config_file       = false
  # version                = "~> 1.10"
}
