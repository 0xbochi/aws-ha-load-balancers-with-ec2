resource "aws_key_pair" "alb_keypair" {
  key_name   = "bochiKey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "LaunchTemplateProject"
  image_id      = "ami-09fd16644beea3565"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.alb_keypair.key_name

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx
yum install -y stress
echo $HOSTNAME > /usr/share/nginx/html/index.html
EOF
  )

  vpc_security_group_ids = [aws_security_group.SG_EC2_Projet.id]
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 6
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.az_subnet_1a.id, aws_subnet.az_subnet_1b.id]
  target_group_arns   = [aws_lb_target_group.lb_tg.arn]
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "TargetTrackingPolicy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30
  }
}
