#  EC2 instance
# output "bastion_ip" {
#   value = module.bastion.bastion_ip
# }

# output "bastion_dns" {
#   value = module.bastion.bastion_dns
# }

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
output "vpc_id" {
  value = "\"${module.vpc.vpc_id}\""
}
output "alb_security_gp" {
  value = [module.sg.ecs_infa_to_alb_sg_id]
}
output "public_subnets_list" {
  value = module.vpc.pub_subnet_id
}
output "private_subnets_list" {
  value = module.vpc.pvt_subnet_id
}
output "noegress_sg_list" {
  value = [module.sg.no_egress_sg_id]
}
output "alb_logs_bucket" {
  value = "\"${module.s3.s3_logging_id}\""
}
