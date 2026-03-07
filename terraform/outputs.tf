output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}

output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}
