######### Jump host #########

resource "aws_security_group" "jump_sg" {
  name   = "${var.prefix}-jump-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-jump-sg" }
}

######### Public ALB #########

resource "aws_security_group" "alb_sg" {
  name   = "${var.prefix}-alb-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-alb-sg" }
}

######### Dashboard v1 #########

resource "aws_security_group" "dashboard_v1_sg" {
  name   = "${var.prefix}-dashboard-v1-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    description     = "App traffic from public ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from jump host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-dashboard-v1-sg" }
}

######### Dashboard v2 #########

resource "aws_security_group" "dashboard_v2_sg" {
  name   = "${var.prefix}-dashboard-v2-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    description     = "App traffic from public ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from jump host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-dashboard-v2-sg" }
}

######### Internal ALB (fronts counting) #########

resource "aws_security_group" "counting_alb_sg" {
  name   = "${var.prefix}-counting-alb-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    description     = "From dashboard v1"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_v1_sg.id]
  }

  ingress {
    description     = "From dashboard v2"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_v2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-counting-alb-sg" }
}

######### Counting #########

resource "aws_security_group" "counting_sg" {
  name   = "${var.prefix}-counting-sg"
  vpc_id = aws_vpc.dash_count_app.id

  ingress {
    description     = "App traffic from internal ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.counting_alb_sg.id]
  }

  ingress {
    description     = "SSH from dashboard v1 (no direct jump-host access)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_v1_sg.id]
  }

  ingress {
    description     = "SSH from dashboard v2 (no direct jump-host access)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_v2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.prefix}-counting-sg" }
}
