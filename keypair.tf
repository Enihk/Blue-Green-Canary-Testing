resource "tls_private_key" "jump_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jump_keypair" {
  key_name   = "${var.prefix}-jump-keypair"
  public_key = tls_private_key.jump_keypair.public_key_openssh
}

resource "tls_private_key" "dashboard_v1_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dashboard_v1_keypair" {
  key_name   = "${var.prefix}-dashboard-v1-keypair"
  public_key = tls_private_key.dashboard_v1_keypair.public_key_openssh
}

resource "tls_private_key" "dashboard_v2_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dashboard_v2_keypair" {
  key_name   = "${var.prefix}-dashboard-v2-keypair"
  public_key = tls_private_key.dashboard_v2_keypair.public_key_openssh
}

resource "tls_private_key" "counting_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "counting_keypair" {
  key_name   = "${var.prefix}-counting-keypair"
  public_key = tls_private_key.counting_keypair.public_key_openssh
}
