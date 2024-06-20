# Created Stage Application Load balancer
resource "aws_lb" "stage-alb" {
  name               = "stage-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets
  tags = {
  Name = "stage-alb"
  }
}

# Creating Target Group
resource "aws_lb_target_group" "stage-tg" {
  name             = "stage-tg-alb"
  port             = 30001
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener" "stage-listener" {
  load_balancer_arn = aws_lb.stage-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.k8s-cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-tg.arn
  }
}

resource "aws_lb_listener" "stage-listener2" {
  load_balancer_arn = aws_lb.stage-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "stage-attachment" {
  target_group_arn = aws_lb_target_group.stage-tg.arn
  target_id        = element(var.instance, count.index)
  port             = 30001
  count = 3
}
