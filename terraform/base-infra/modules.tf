
# VPC
module "vpc" {
  source              = "./modules/vpc"
  project_prefix      = local.project_prefix
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  nat_count           = var.nat_count
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  s3_logging_arn      = module.s3.s3_logging_arn
}

# Security Groups
module "sg" {
  source                 = "./modules/sg"
  project_prefix         = local.project_prefix
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  vpc_cidr               = var.vpc_cidr
  bastion_ssh_port       = var.bastion_ssh_port
  wireguard_vpc_cidr_dev = var.wireguard_vpc_cidr_dev
  wireguard_vpc_cidr_prd = var.wireguard_vpc_cidr_prd
}

# S3
module "s3" {
  source         = "./modules/s3"
  project_prefix = local.project_prefix
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  region         = var.region
  account_id     = data.aws_caller_identity.current.account_id
}

# Bastion
module "bastion" {
  source                   = "./modules/bastion"
  bastion_count            = var.enable_bastion == true ? 1 : 0
  project_prefix           = local.project_prefix
  environment              = var.environment
  region                   = var.region
  vpc_id                   = module.vpc.vpc_id
  ssh_access_sg            = module.sg.ssh_access_sg_id
  pub_subnet_id            = module.vpc.pub_subnet_id
  bastion_instance_type    = var.bastion_instance_type
  ec2_kp_sudo_pub_key      = var.ec2_kp_sudo_pub_key
  ec2_kp_developer_pub_key = var.ec2_kp_developer_pub_key
  bastion_ssh_port         = var.bastion_ssh_port
}

# Requires SCP Guardrail edit 
# AWS Config
module "aws-config" {
  source         = "./modules/aws-config"
  project_prefix = local.project_prefix
  logging_s3     = module.s3.s3_logging_id
  environment    = var.environment
  account_id     = data.aws_caller_identity.current.account_id
}

# Cloudtrail
module "cloudtrail" {
  source         = "./modules/cloudtrail"
  project_prefix = local.project_prefix
  logging_s3     = module.s3.s3_logging_id
  environment    = var.environment
}

# Inspector 
module "inspector" {
  source         = "./modules/inspector"
  project_prefix = local.project_prefix
  environment    = var.environment
}
