output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "pub_subnet_id" {
  value = aws_subnet.public_subnet.*.id
}
output "pvt_subnet_id" {
  value = aws_subnet.private_subnet.*.id
}
output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}
