resource "aws_instance" "jump_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jump_instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.jump_keypair.key_name
  vpc_security_group_ids      = [aws_security_group.jump_sg.id]

  tags = {
    Name = "${var.prefix}-jump-host"
  }
}

resource "aws_eip" "jump_eip" {
  instance = aws_instance.jump_host.id
  domain   = "vpc"

  tags = {
    Name = "${var.prefix}-jump-eip"
  }
}
