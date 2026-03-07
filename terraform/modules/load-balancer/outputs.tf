output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  value = aws_lb.auth_alb.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}
