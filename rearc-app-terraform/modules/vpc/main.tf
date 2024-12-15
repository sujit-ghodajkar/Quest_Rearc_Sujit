resource "aws_vpc" "rearc_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rearc-app-vpc"
  }
}

resource "aws_subnet" "rearc_app_subnets" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.rearc_app_vpc.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.rearc_app_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "rearc-app-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "rearc_app_igw" {
  vpc_id = aws_vpc.rearc_app_vpc.id
  tags = {
    Name = "rearc-app-igw"
  }
}

resource "aws_route_table" "rearc_app_route_table" {
  vpc_id = aws_vpc.rearc_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rearc_app_igw.id
  }
}

resource "aws_route_table_association" "rearc_app_rta" {
  count          = length(aws_subnet.rearc_app_subnets)
  subnet_id      = aws_subnet.rearc_app_subnets[count.index].id
  route_table_id = aws_route_table.rearc_app_route_table.id
}
