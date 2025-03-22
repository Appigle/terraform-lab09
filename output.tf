output "load_balancer_dns" {
  value = aws_lb.nginx.dns_name
}

output "webserver_public_ips" {
  value = {
    for k, v in aws_instance.webservers : k => v.public_ip
  }
}

output "environment" {
  value = local.environment
}

output "security_group_rule_count" {
  value = length(local.public_sg_rules)
}