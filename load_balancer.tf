
resource "aws_lb" "app_lb" {
  name               = "LoadBalancerProjet"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG_LB_Projet.id]
  subnets            = [aws_subnet.az_subnet_2a.id, aws_subnet.az_subnet_2b.id]
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "TargetGroupProjet"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC_Projet.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}
