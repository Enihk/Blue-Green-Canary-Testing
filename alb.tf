######### Public ALB - single domain, weighted blue/green split v1/v2 #########

resource "aws_lb" "public" {
  name               = "${var.prefix}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  tags = { Name = "${var.prefix}-public-alb" }
}

resource "aws_lb_target_group" "dashboard_v1" {
  name     = "${var.prefix}-dash-v1-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dash_count_app.id

  health_check {
    path                = var.dashboard_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  tags = { Name = "${var.prefix}-dash-v1-tg" }
}

resource "aws_lb_target_group" "dashboard_v2" {
  name     = "${var.prefix}-dash-v2-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dash_count_app.id

  health_check {
    path                = var.dashboard_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  tags = { Name = "${var.prefix}-dash-v2-tg" }
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.app.certificate_arn

  # Single domain, single decision point: every request is weighted across
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.dashboard_v1.arn
        weight = var.dashboard_v1_weight
      }

      target_group {
        arn    = aws_lb_target_group.dashboard_v2.arn
        weight = var.dashboard_v2_weight
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

######### Internal ALB - counting #########

resource "aws_lb" "counting_internal" {
  name               = "${var.prefix}-counting-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.counting_alb_sg.id]
  subnets            = aws_subnet.counting[*].id

  tags = { Name = "${var.prefix}-counting-alb" }
}

resource "aws_lb_target_group" "counting" {
  name     = "${var.prefix}-counting-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dash_count_app.id

  health_check {
    path                = var.counting_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  tags = { Name = "${var.prefix}-counting-tg" }
}

resource "aws_lb_listener" "counting_http" {
  load_balancer_arn = aws_lb.counting_internal.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting.arn
  }
}
