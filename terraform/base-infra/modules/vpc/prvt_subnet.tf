#####
# VPC Private Subnets
#####

## NAT gateway elastic IPs
resource "aws_eip" "nat_gateway" {
  count = var.nat_count
  vpc   = true

  tags = {
    Name        = "${var.project_prefix}-NAT-${count.index + 1}"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

## NAT gateways
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.nat_count
  allocation_id = element(aws_eip.nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name        = "${var.project_prefix}-NAT-${count.index + 1}"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat_gateway,
  ]
}

## Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                              = "${var.project_prefix}-private-${count.index + 1}"
    environment                       = var.environment
    CreatedBy                         = "Terraform"
    "kubernetes.io/role/internal-elb" = 1
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

## Private Route Tables
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_prefix}-private"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Egress route to internet (GitHub/GitLab)
resource "aws_route" "nat" {
  count                  = var.nat_count
  route_table_id         = aws_route_table.private_rt.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id

}

## Associate the private route tables with the private subnets
resource "aws_route_table_association" "private1" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

