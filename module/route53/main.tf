# Create Route53 Hosted Zone
data "aws_route53_zone" "k8s-route53" {
  name         = "thinkeod.com"
  private_zone = false
}

# Create A Record For Production Environment
resource "aws_route53_record" "production_record" {
  zone_id = data.aws_route53_zone.k8s-route53.zone_id
  name    = "prod.thinkeod.com"
  type    = "A"

  alias {
    name                   = var.prod_lb_dns_name
    zone_id                = var.prod_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Stage Environment
resource "aws_route53_record" "stage_record" {
  zone_id = data.aws_route53_zone.k8s-route53.zone_id
  name    = "stage.thinkeod.com"
  type    = "A"

  alias {
    name                   = var.stage_lb_dns_name
    zone_id                = var.stage_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Prometheus
resource "aws_route53_record" "prometheus_record" {
  zone_id = data.aws_route53_zone.k8s-route53.zone_id
  name    = "prometheus.thinkeod.com"
  type    = "A"

  alias {
    name                   = var.prometheus_lb_dns_name
    zone_id                = var.prometheus_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Grafana
resource "aws_route53_record" "grafana_record" {
  zone_id = data.aws_route53_zone.k8s-route53.zone_id
  name    = "grafana.thinkeod.com"
  type    = "A"

  alias {
    name                   = var.grafana_lb_dns_name
    zone_id                = var.grafana_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Jenkins
resource "aws_route53_record" "jenkins-record" {
  zone_id = data.aws_route53_zone.k8s-route53.zone_id
  name    = "jenkins.thinkeod.com"
  type    = "A"

  alias {
    name                   = var.jenkins_lb_dns_name
    zone_id                = var.jenkins_lb_zone_id
    evaluate_target_health = true
  }
}

#  Create ACM Certificate
resource "aws_acm_certificate" "k8s-acm-certificate" {
  domain_name       = "thinkeod.com"
  subject_alternative_names = ["*.thinkeod.com"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Create route53 validation record
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.k8s-acm-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.k8s-route53.zone_id
}

# Create acm certificate validition
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.k8s-acm-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}