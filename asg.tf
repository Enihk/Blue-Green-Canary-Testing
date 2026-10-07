######### Dashboard v1 ASG (private subnets 1 & 2) #########

resource "aws_autoscaling_group" "dashboard_v1" {
  name                      = "${var.prefix}-dashboard-v1-asg"
  vpc_zone_identifier       = aws_subnet.dashboard_v1[*].id
  target_group_arns         = [aws_lb_target_group.dashboard_v1.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60

  min_size         = var.dashboard_v1_min_size
  max_size         = var.dashboard_v1_max_size
  desired_capacity = var.dashboard_v1_desired_capacity

  launch_template {
    id      = aws_launch_template.dashboard_v1.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-dashboard-v1-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "dashboard_v1_cpu" {
  name                   = "${var.prefix}-dashboard-v1-cpu-tracking"
  autoscaling_group_name = aws_autoscaling_group.dashboard_v1.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}

######### Dashboard v2 ASG (private subnets 3 & 4) #########

resource "aws_autoscaling_group" "dashboard_v2" {
  name                      = "${var.prefix}-dashboard-v2-asg"
  vpc_zone_identifier       = aws_subnet.dashboard_v2[*].id
  target_group_arns         = [aws_lb_target_group.dashboard_v2.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60

  min_size         = var.dashboard_v2_min_size
  max_size         = var.dashboard_v2_max_size
  desired_capacity = var.dashboard_v2_desired_capacity

  launch_template {
    id      = aws_launch_template.dashboard_v2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-dashboard-v2-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "dashboard_v2_cpu" {
  name                   = "${var.prefix}-dashboard-v2-cpu-tracking"
  autoscaling_group_name = aws_autoscaling_group.dashboard_v2.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}

######### Counting ASG (private subnets 5 & 6) #########

resource "aws_autoscaling_group" "counting" {
  name                      = "${var.prefix}-counting-asg"
  vpc_zone_identifier       = aws_subnet.counting[*].id
  target_group_arns         = [aws_lb_target_group.counting.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60

  min_size         = var.counting_min_size
  max_size         = var.counting_max_size
  desired_capacity = var.counting_desired_capacity

  launch_template {
    id      = aws_launch_template.counting.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-counting-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "counting_cpu" {
  name                   = "${var.prefix}-counting-cpu-tracking"
  autoscaling_group_name = aws_autoscaling_group.counting.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}
