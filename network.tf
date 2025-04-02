# NETWORKING
resource "aws_vpc" "webapp" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "PROP8830-GROUP1-LAB08"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.webapp.id
  tags = {
    "Name" = "PROP8830-GROUP1-LAB08"
  }
}

locals {
  public_subnets = {
    subnet1 = {
      cidr_block = "10.0.2.0/24"
    }
    subnet2 = {
      cidr_block = "10.0.3.0/24"
    }
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.webapp.id
  cidr_block              = each.value.cidr_block
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "PROP8830-GROUP1-LAB08"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.webapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    "Name" = "PROP8830-GROUP1-LAB08"
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}