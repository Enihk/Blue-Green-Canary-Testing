output "dashboard_url" {
  description = "Single dashboard URL - ALB splits traffic 30/70 (or whatever weights you set) across v1/v2 behind this one domain."
  value       = "https://${var.dashboard_subdomain}.${var.domain_name}"
}

output "counting_internal_url" {
  value = "http://counting.${var.internal_domain}:8080"
}

output "public_alb_dns_name" {
  value = aws_lb.public.dns_name
}

output "jump_host_public_ip" {
  value = aws_eip.jump_eip.public_ip
}

output "jump_host_private_key_pem" {
  value     = tls_private_key.jump_keypair.private_key_pem
  sensitive = true
}

output "dashboard_v1_private_key_pem" {
  value     = tls_private_key.dashboard_v1_keypair.private_key_pem
  sensitive = true
}

output "dashboard_v2_private_key_pem" {
  value     = tls_private_key.dashboard_v2_keypair.private_key_pem
  sensitive = true
}

output "counting_private_key_pem" {
  value     = tls_private_key.counting_keypair.private_key_pem
  sensitive = true
}

output "vpc_id" {
  value = aws_vpc.dash_count_app.id
}

output "dashboard_v1_asg_name" {
  value = aws_autoscaling_group.dashboard_v1.name
}

output "dashboard_v2_asg_name" {
  value = aws_autoscaling_group.dashboard_v2.name
}

output "counting_asg_name" {
  value = aws_autoscaling_group.counting.name
}

output "public_hosted_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

output "private_hosted_zone_id" {
  value = aws_route53_zone.internal.zone_id
}
