# LOAD BALANCER 
resource "aws_lb" "nginx" {
  name               = "prog8830-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sec_group.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Name = "us-east-1"
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginxtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webapp.id
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

resource "aws_lb_target_group_attachment" "nginx1" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "nginx2" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}
