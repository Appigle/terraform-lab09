# LOAD BALANCER 
resource "aws_lb" "nginx" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sec_group.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "PROP8830-GROUP1-LAB08"
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginxtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webapp.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "nginx_attachments" {
  for_each = aws_instance.webservers

  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = each.value.id
  port             = 80
}
