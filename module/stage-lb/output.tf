output "stage-dns-name" {
  value = aws_lb.stage-alb.dns_name
}

output "stage-zoneid" {
  value = aws_lb.stage-alb.zone_id
}

output "stagelb-arn" {
  value = aws_lb_target_group.stage-tg.arn
}