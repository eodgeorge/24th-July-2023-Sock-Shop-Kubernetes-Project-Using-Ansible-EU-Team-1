output "prometheus_lb_dns_name" {
  value = aws_lb.prometheus-alb.dns_name
}

output "prometheus_lb_zone_id" {
  value = aws_lb.prometheus-alb.zone_id
}

output "grafana_lb_dns_name" {
  value = aws_lb.grafana-alb.dns_name
}

output "grafana_lb_zone_id" {
  value = aws_lb.grafana-alb.zone_id
}

output "prometheus-arn" {
  value = aws_lb_target_group.prometheus-target.arn
}

output "grafana-arn" {
  value = aws_lb_target_group.grafana-target.arn
}