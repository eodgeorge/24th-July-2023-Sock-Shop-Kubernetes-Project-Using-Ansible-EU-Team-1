resource "aws_launch_template" "asg-launch-tem" {
  name_prefix   = "asg-launch"
  image_id      = "ami-0eb260c4d5475b901"
  instance_type = "t2.medium"
  key_name = var.keypair
  vpc_security_group_ids = [var.worker-nodes-sg]
}
#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "launch-template"
#     }
#   }
# }

resource "aws_autoscaling_group" "asg" {
  name = "asg-work"
  desired_capacity   = 3
  max_size           = 5
  min_size           = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  target_group_arns         = var.tg-arn
  vpc_zone_identifier       = [var.prv-sub1, var.prv-sub2, var.prv-sub3 ]

  launch_template {
    id      = aws_launch_template.asg-launch-tem.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "asg-work"
    propagate_at_launch = true
  }
}

# Creating ASG Policy
resource "aws_autoscaling_policy" "Team1-ASG-Policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "Team1-ASG-Policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}