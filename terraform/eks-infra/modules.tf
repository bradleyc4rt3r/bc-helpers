
# EKS
module "eks" {
  source                  = "./modules/eks"
  project_prefix          = local.project_prefix
  environment             = var.environment
  project                 = var.project
  vpc_id                  = data.aws_vpc.main.id
  private_subnet          = data.aws_subnet_ids.private.ids
  public_subnet           = data.aws_subnet_ids.public.ids
  private_security_group  = data.aws_security_group.private.id
  ubuntu_ami              = data.aws_ami.ubuntu_ami.id
  key_pair                = "${local.project_prefix}-kp-ec2"
  node_instance_type      = var.eks_node_instance_type
  node_disk_size          = var.eks_node_disk_size
  node_capacity_type      = var.eks_node_capacity_type
  node_kubernetes_version = var.eks_node_kubernetes_version
  node_desired_size       = var.eks_node_desired_size
  node_max_size           = var.eks_node_max_size
  node_min_size           = var.eks_node_min_size
}

# EFS
module "efs" {
  source                 = "./modules/efs"
  project_prefix         = local.project_prefix
  environment            = var.environment
  vpc_id                 = data.aws_vpc.main.id
  vpc_cidr               = data.aws_vpc.main.cidr_block
  private_subnet         = data.aws_subnet_ids.private.ids
  private_security_group = data.aws_security_group.private.id
}

# # Kubernetes
module "kubernetes" {
  source         = "./modules/kubernetes"
  project_prefix = local.project_prefix
  environment    = var.environment
  project        = var.project
  region         = var.region
  vpc_id         = data.aws_vpc.main.id
  account_id     = data.aws_caller_identity.current.account_id
  cluster_id     = module.eks.eks_cluster_id
  cluster_name   = module.eks.eks_cluster_name
}

# ECR 
module "ecr" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
}

