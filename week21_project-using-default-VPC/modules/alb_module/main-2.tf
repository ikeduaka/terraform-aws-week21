resource "aws_lb" "week21_alb" {
  name               = "week21-alb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_lb_listener" "week21_lb_listener" {
  load_balancer_arn = aws_lb.week21_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.week21_tg.arn
  }
}

resource "aws_lb_target_group" "week21_tg" {
 name        = "week21-tg"
 target_type = "instance"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  }
  