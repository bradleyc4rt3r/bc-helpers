# output "region_code" {
#   value = var.region_code[var.region]
# }

output "environment" {
  value = var.environment
}

output "loadbalancer_dns_name" {
  value = [module.backend_alb.ec2_lb_dns_name]
}
