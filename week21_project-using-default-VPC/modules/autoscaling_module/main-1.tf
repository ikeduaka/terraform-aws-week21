resource "aws_autoscaling_group" "week21_asg" {
  name             = "week21_asg"
  max_size         = 5
  min_size         = 2
  desired_capacity = 2
  target_group_arns = var.target_group_arns

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = var.launch_template #aws_launch_template.week21_launch_template.id
    version = "$Latest"
  }
}