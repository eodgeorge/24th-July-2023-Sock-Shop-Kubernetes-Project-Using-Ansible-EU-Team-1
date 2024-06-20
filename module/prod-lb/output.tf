output "prod-dns-name" {
  value = aws_lb.prod-alb.dns_name
}

output "prod-zoneid" {
  value = aws_lb.prod-alb.zone_id
}

output "prodlb-arn" {
  value = aws_lb_target_group.prod-tg.arn
}