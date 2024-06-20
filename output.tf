output "jenkins-lb" {
  value = module.JENKINS.jenkins_dns
}

output "jenkins-ip" {
  value = module.JENKINS.jenkins_private_ip
}

output "bastion-ip" {
  value = module.BASTION.bastion-ip
}

output "Haproxy_private_ip" {
  value = module.HAPROXY.Haproxy_private_ip
}

output "Haproxybkup_private_ip" {
  value = module.HAPROXY.Haproxybkup_private_ip
}

output "Ansible" {
  value = module.ANSIBLE.ansible-ip
}

output "master-node-ip" {
  value = module.MASTER-NODE.master-node-ip
}

output "worker-node-ip" {
  value = module.WORKER-NODE.Worker_nodes_private_ip
}

# output "certificate_arn" {
#   value = module.ssl-certificate.certificate_arn
# }

# output "route53-server" {
#   value = module.route53.route53_dns-name
# }

output "stage-lb" {
  value = module.STAGE-LB.stage-dns-name
}

output "prod-lb" {
  value = module.PRODUCTION-LB.prod-dns-name
}

output "grafana-lb" {
  value = module.PROMETHEUS-GRAFANA-LB.grafana_lb_dns_name
}

output "prometheus-lb" {
  value = module.PROMETHEUS-GRAFANA-LB.prometheus_lb_dns_name
}