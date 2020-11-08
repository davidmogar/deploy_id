resource "aws_security_group" "bastion" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public
  ]

  name        = "bastion"
  description = "Allow traffic to ssh port"
  vpc_id      = aws_vpc.main.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.ami[var.region]
  instance_type          = var.instance
  key_name               = "deploy_it"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
}
