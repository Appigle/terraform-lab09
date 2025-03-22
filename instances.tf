provider "aws" {
  region = "us-east-1"
}

# INSTANCE
resource "aws_instance" "webserver1" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.load_balancer_sec_group.id]
  subnet_id              = aws_subnet.public_subnet_1.id

  user_data = file("./setup-nginx.sh")
}

# INSTANCE
resource "aws_instance" "webserver2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.load_balancer_sec_group.id]

  user_data = file("./setup-nginx.sh")
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = "LabRole"

}