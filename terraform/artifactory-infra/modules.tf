# Loab Balancer
module "backend_alb" {
  source                 = "./modules/alb"
  project_prefix         = local.project_prefix
  environment            = var.environment
  region                 = var.region
  account_id             = data.aws_caller_identity.current.account_id
  vpc_id                 = data.aws_vpc.main.id
  alb_security_gp        = [data.aws_security_group.loabbalancer.id]
  alb_subnet_list        = data.aws_subnet_ids.public.ids
  alb_health_check_path  = var.alb_health_check_path
  alb_health_status_code = var.alb_health_status_code
  domain_name            = var.domain_name
}

# EC2 artifactory
module "ec2_artifactory" {
  source                         = "./modules/ec2-artifactory"
  region                         = var.region
  vpc_id                         = data.aws_vpc.main.id
  vpc_cidr                       = data.aws_vpc.main.cidr_block
  project_prefix                 = local.project_prefix
  environment                    = var.environment
  ec2_subnets                    = data.aws_subnet_ids.private.ids
  ec2_artifactory_instance_type  = var.ec2_artifactory_instance_type
  ec2_artifactory_security_group = data.aws_security_group.private.id
  ec2_artifactory_key_name       = "${local.project_prefix}-kp-ec2"
  ec2_artifactory_launch_version = var.ec2_artifactory_launch_version
  ec2_artifactory_min_count      = var.ec2_artifactory_min_count
  ec2_artifactory_desired_count  = var.ec2_artifactory_desired_count
  ec2_artifactory_max_count      = var.ec2_artifactory_max_count
  target_group_arn               = module.backend_alb.ec2_artifactory_tg_arn
  wireguard_vpc_cidr_dev         = var.wireguard_vpc_cidr_dev
  wireguard_vpc_cidr_prd         = var.wireguard_vpc_cidr_prd
  jenkins_vpc_cidr               = var.jenkins_vpc_cidr
  artifactory_bucket             = module.s3.s3_artifactory_id
  domain_name                    = var.domain_name
}

# S3
module "s3" {
  source         = "./modules/s3"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
}
