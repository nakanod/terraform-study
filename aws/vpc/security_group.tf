resource "aws_security_group" "mydefault" {
  name = "mydefault"
  description = "My default SG"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH from allowed ip address"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "192.0.2.50/32",
      "192.0.2.100/32",
      "192.0.2.200/32",
    ]
  }

  ingress {
    description = "RDP from allowed ip address"
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = [
      "192.0.2.50/32",
      "192.0.2.100/32",
      "192.0.2.200/32",
    ]
  }

  ingress {
    description = "ping from ip address"
    from_port = 8
    to_port = 8
    protocol = "icmp"
    cidr_blocks = [
      "192.0.2.50/32",
      "192.0.2.100/32",
      "192.0.2.200/32",
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "[Made by TF] mydefault"
  }
}
