locals {
  public_sg_rules = {
    ingress_80 = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  lb_sg_rules = {
    ingress_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  min_port = min([for k, v in local.public_sg_rules : v.from_port if startswith(k, "ingress")]...)
  max_port = max([for k, v in local.public_sg_rules : v.to_port if startswith(k, "ingress")]...)
}

resource "aws_security_group" "public_security_group" {
  name        = "public security group"
  description = "PROG8830 security group"
  vpc_id      = aws_vpc.webapp.id

  dynamic "ingress" {
    for_each = { for k, v in local.public_sg_rules : k => v if startswith(k, "ingress") }
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = { for k, v in local.public_sg_rules : k => v if startswith(k, "egress") }
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name        = "PROP8830-GROUP1-LAB08"
    MinPort     = local.min_port
    MaxPort     = local.max_port
  }
}

resource "aws_security_group" "load_balancer_sec_group" {
  name        = "load_balancer_sec_group"
  description = "security group for load balancer"
  vpc_id      = aws_vpc.webapp.id

  dynamic "ingress" {
    for_each = { for k, v in local.lb_sg_rules : k => v if startswith(k, "ingress") }
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = { for k, v in local.lb_sg_rules : k => v if startswith(k, "egress") }
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}