#  EC2 instance
output "bastion_ip" {
  value = join("", aws_instance.bastion.*.public_ip)
}

output "bastion_dns" {
  value = join("", aws_instance.bastion.*.public_dns)
}
