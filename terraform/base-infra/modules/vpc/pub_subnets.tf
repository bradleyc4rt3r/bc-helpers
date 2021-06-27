#####
# VPC Public Subnets
#####

## Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_prefix}-public-${count.index + 1}"
    environment              = var.environment
    CreatedBy                = "Terraform"
    "kubernetes.io/role/elb" = 1
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

## Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_prefix}-igw"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

## Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_prefix}-public"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

## Attach a 0/0 route to the public route table going through the IGW
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  depends_on = [
    aws_internet_gateway.igw,
    aws_route_table.public_rt,
  ]
}

## Public Subnet Route Table associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

