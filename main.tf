locals {
  name = "K8s-team"
}

module "VPC" {
  source     = "./module/vpc"
  cidr_block = "10.0.0.0/16"
}

module "KEYPAIR" {
  source = "./module/keypair"
}

module "SECURITY-GROUP" {
  source = "./module/security-group"
  vpc_id = module.VPC.vpc_id
}

module "SUBNET" {
  source = "./module/subnet"
  vpc_id = module.VPC.vpc_id
}

#creating ansible-server
module "ANSIBLE" {
  source           = "./module/ansible"
  depends_on       = [module.ASG.asg]
  ami              = "ami-0eb260c4d5475b901"
  instance_type    = "t2.micro"
  private_subnet   = module.SUBNET.prvsub1
  ansible_sg       = module.SECURITY-GROUP.ansible-sg-id
  keypair          = module.KEYPAIR.key-id
  private_key      = module.KEYPAIR.prv-keypair
  haproxy          = module.HAPROXY.Haproxy_private_ip
  haproxy-backupIP = module.HAPROXY.Haproxybkup_private_ip
  main-masterIP    = module.MASTER-NODE.master-node-ip[0]
  member-masterIP1 = module.MASTER-NODE.master-node-ip[1]
  member-masterIP2 = module.MASTER-NODE.master-node-ip[2]
  worker-node1     = module.WORKER-NODE.Worker_nodes_private_ip[0]
  worker-node2     = module.WORKER-NODE.Worker_nodes_private_ip[1]
  worker-node3     = module.WORKER-NODE.Worker_nodes_private_ip[2]
  bastion_host     = module.BASTION.bastion-ip
  tag1             = "${local.name}-ansible"
  asg-work         = module.ASG.asg-name
}


# Creating Haproxy Frontend and Backend servers
module "HAPROXY" {
  source          = "./module/haproxy-servers"
  ami             = "ami-0eb260c4d5475b901"
  instance_type   = "t2.micro"
  private_subnet1 = module.SUBNET.prvsub1
  private_subnet2 = module.SUBNET.prvsub2
  haproxy_sg      = module.SECURITY-GROUP.master-node-sg
  keypair         = module.KEYPAIR.key-id
  master1         = module.MASTER-NODE.master-node-ip[0]
  master2         = module.MASTER-NODE.master-node-ip[1]
  master3         = module.MASTER-NODE.master-node-ip[2]
  master4         = module.MASTER-NODE.master-node-ip[0]
  master5         = module.MASTER-NODE.master-node-ip[1]
  master6         = module.MASTER-NODE.master-node-ip[2]
  tag1            = "${local.name}-haproxy"
  tag2            = "${local.name}-haproxybkup"
}

module "JENKINS" {
  source                    = "./module/jenkins"
  ami-redhat                = "ami-07fb9d5c721566c65"
  instance-type             = "t2.medium"
  keypair                   = module.KEYPAIR.key-id
  privatesub1               = module.SUBNET.prvsub2
  jenkins_security_group_id = module.SECURITY-GROUP.jenkins-sg-id
  elb-name                  = "${local.name}-elb-name"
  subnet_ids                = [module.SUBNET.pubsub1, module.SUBNET.pubsub2, module.SUBNET.pubsub3]
  Jenkins_Server            = "${local.name}-Jenkins_server"
  cert-jenkins              = module.ROUTE53.k8s-acm-cert
}

module "BASTION" {
  source               = "./module/bastion-host"
  ami                  = "ami-0eb260c4d5475b901"
  instance_type        = "t2.micro"
  bastion-SG           = module.SECURITY-GROUP.bastion-sg-id
  key_name             = module.KEYPAIR.key-id
  subnetid             = module.SUBNET.pubsub1
  private_keypair_path = module.KEYPAIR.prv-keypair
  tags                 = "${local.name}-bastion-host"
}

module "WORKER-NODE" {
  source                 = "./module/worker-node"
  AMI-ubuntu             = var.AMI-ubuntu
  instanceType-t2-medium = var.instanceType-t2-medium
  pub-key                = module.KEYPAIR.key-id
  prvsub-id              = module.SUBNET.prvsub-id
  worker-node-sg         = module.SECURITY-GROUP.worker-node-sg
  instance-count         = var.instance-count
  tag                    = "${local.name}-worker-node"
}

module "MASTER-NODE" {
  source                 = "./module/master-node"
  AMI-ubuntu             = var.AMI-ubuntu
  instanceType-t2-medium = var.instanceType-t2-medium
  pub-key                = module.KEYPAIR.key-id
  prvsub-id              = module.SUBNET.prvsub-id
  master-node-sg         = module.SECURITY-GROUP.master-node-sg
  instance-count         = var.instance-count
  tag                    = "${local.name}-master-node"
}

module "PROMETHEUS-GRAFANA-LB" {
  source          = "./module/prometheus-grafana-lb"
  security_groups = module.SECURITY-GROUP.worker-node-sg
  subnets         = [module.SUBNET.pubsub1, module.SUBNET.pubsub2, module.SUBNET.pubsub3]
  certificate-arn = module.ROUTE53.k8s-acm-cert
  vpc_id          = module.VPC.vpc_id
  instance        = module.WORKER-NODE.worker-node_id
}

module "PRODUCTION-LB" {
  source          = "./module/prod-lb"
  security_groups = module.SECURITY-GROUP.worker-node-sg
  subnets         = [module.SUBNET.pubsub1, module.SUBNET.pubsub2, module.SUBNET.pubsub3]
  vpc_id          = module.VPC.vpc_id
  instance        = module.WORKER-NODE.worker-node_id
  k8s-cert-arn    = module.ROUTE53.k8s-acm-cert
}

module "STAGE-LB" {
  source          = "./module/stage-lb"
  security_groups = module.SECURITY-GROUP.worker-node-sg
  subnets         = [module.SUBNET.pubsub1, module.SUBNET.pubsub2, module.SUBNET.pubsub3]
  vpc_id          = module.VPC.vpc_id
  instance        = module.WORKER-NODE.worker-node_id
  k8s-cert-arn    = module.ROUTE53.k8s-acm-cert
}

# Creating Route53 
module "ROUTE53" {
  source                 = "./module/route53"
  prod_lb_dns_name       = module.PRODUCTION-LB.prod-dns-name
  prod_lb_zone_id        = module.PRODUCTION-LB.prod-zoneid
  stage_lb_dns_name      = module.STAGE-LB.stage-dns-name
  stage_lb_zone_id       = module.STAGE-LB.stage-zoneid
  prometheus_lb_dns_name = module.PROMETHEUS-GRAFANA-LB.prometheus_lb_dns_name
  prometheus_lb_zone_id  = module.PROMETHEUS-GRAFANA-LB.prometheus_lb_zone_id
  grafana_lb_dns_name    = module.PROMETHEUS-GRAFANA-LB.grafana_lb_dns_name
  grafana_lb_zone_id     = module.PROMETHEUS-GRAFANA-LB.grafana_lb_zone_id
  jenkins_lb_dns_name    = module.JENKINS.jenkins_dns
  jenkins_lb_zone_id     = module.JENKINS.jenkins_zoneid
}

#creating ASG
module "ASG" {
  source          = "./module/asg"
  prv-sub1        = module.SUBNET.prvsub1
  prv-sub2        = module.SUBNET.prvsub2
  prv-sub3        = module.SUBNET.prvsub3
  keypair         = module.KEYPAIR.key-id
  worker-nodes-sg = module.SECURITY-GROUP.worker-node-sg
  tg-arn          = [module.PRODUCTION-LB.prodlb-arn, module.PROMETHEUS-GRAFANA-LB.prometheus-arn, module.PROMETHEUS-GRAFANA-LB.grafana-arn, module.STAGE-LB.stagelb-arn]
}