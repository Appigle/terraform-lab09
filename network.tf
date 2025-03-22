# NETWORKING
resource "aws_vpc" "webapp" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.webapp.id
  tags = {
    "Name" = "PROG8830-Week10"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.webapp.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "PROG8830-Week10"
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.webapp.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "PROG8830-Week10"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.webapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    "Name" = "PROG8830-Week10"
  }
}

resource "aws_route_table_association" "public_subnet_1_route_table" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_route_table" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "public_subnet_group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "pg"
  family = "postgres16"

  parameter {
    name  = "log_connection"
    value = 1
  }
}