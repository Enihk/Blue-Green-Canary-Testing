resource "aws_launch_template" "dashboard_v1" {
  name_prefix   = "${var.prefix}-dashboard-v1-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.dashboard_v1_instance_type
  key_name      = aws_key_pair.dashboard_v1_keypair.key_name

  vpc_security_group_ids = [aws_security_group.dashboard_v1_sg.id]

  user_data = base64encode(templatefile("${path.module}/scripts/dashboard_v1.sh", {
    counting_service_url = "http://counting.${var.internal_domain}:8080"
    private_key          = tls_private_key.counting_keypair.private_key_pem
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.prefix}-dashboard-v1-ec2" }
  }
}

resource "aws_launch_template" "dashboard_v2" {
  name_prefix   = "${var.prefix}-dashboard-v2-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.dashboard_v2_instance_type
  key_name      = aws_key_pair.dashboard_v2_keypair.key_name

  vpc_security_group_ids = [aws_security_group.dashboard_v2_sg.id]

  user_data = base64encode(templatefile("${path.module}/scripts/dashboard_v2.sh", {
    counting_service_url = "http://counting.${var.internal_domain}:8080"
    private_key          = tls_private_key.counting_keypair.private_key_pem
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.prefix}-dashboard-v2-ec2" }
  }
}

resource "aws_launch_template" "counting" {
  name_prefix   = "${var.prefix}-counting-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.counting_instance_type
  key_name      = aws_key_pair.counting_keypair.key_name

  vpc_security_group_ids = [aws_security_group.counting_sg.id]

  user_data = filebase64("${path.module}/scripts/counting.sh")

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.prefix}-counting-ec2" }
  }
}
