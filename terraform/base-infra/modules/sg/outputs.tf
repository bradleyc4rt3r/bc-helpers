
##  Security Group - no egress
output "no_egress_sg_id" {
  value = aws_security_group.no_egress.id
}

##  Security Group - ecs-infa
output "ecs_infa_to_alb_sg_id" {
  value = aws_security_group.ec2_infa_to_alb.id
}

##  Security Group - ssh-access
output "ssh_access_sg_id" {
  value = aws_security_group.ssh_access.id
}

##  Security Group - ecs-instanc
output "private_sg_id" {
  value = aws_security_group.private.id
}
