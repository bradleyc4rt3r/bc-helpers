# ALB
output "ec2_lb_arn" {
  value = aws_lb.ec2_artifactory_alb.arn
}

output "ec2_lb_dns_name" {
  value = aws_lb.ec2_artifactory_alb.dns_name
}

# ec2_artifactory
output "ec2_artifactory_tg_arn" {
  value = aws_lb_target_group.ec2_artifactory_tg.arn
}

