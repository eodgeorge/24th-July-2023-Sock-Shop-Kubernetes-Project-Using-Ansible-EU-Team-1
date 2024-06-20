output "route53_dns-name" {
  value = data.aws_route53_zone.k8s-route53.name_servers
}

output "route53_hosted_zone" {
  value = data.aws_route53_zone.k8s-route53.zone_id
}

output "k8s-acm-cert" {
  value = aws_acm_certificate.k8s-acm-certificate.arn
}