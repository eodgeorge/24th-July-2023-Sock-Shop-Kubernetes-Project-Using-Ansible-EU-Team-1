#Create a Jenkins Server
resource "aws_instance" "Jenkins_Server" {
  ami                           = var.ami-redhat
  instance_type                 = var.instance-type
  key_name                      = var.keypair
  subnet_id                     = var.privatesub1
  vpc_security_group_ids        = [var.jenkins_security_group_id]
  user_data                     = local.jenkins_user_data

  tags = {
    Name = var.Jenkins_Server
  }
}

resource "aws_elb" "jenkins_lb" {
  name            = var.elb-name
  subnets         = var.subnet_ids
  security_groups = [var.jenkins_security_group_id]
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

    listener {
    instance_port      = 8081
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.cert-jenkins
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }
  instances                   = [aws_instance.Jenkins_Server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = var.elb-name
  }
}