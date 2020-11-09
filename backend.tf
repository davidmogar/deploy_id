resource "aws_security_group" "backend" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public
  ]

  name        = "backend"
  description = "Allow traffic to http and ssh ports"
  vpc_id      = aws_vpc.main.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    to_port         = 22
  }
}

resource "aws_instance" "backend" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public,
    aws_security_group.bastion
  ]

  ami                    = var.ami[var.region]
  instance_type          = var.instance
  key_name               = "deploy_it"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.backend.id, aws_security_group.bastion.id]
}

module "keyscan" {
  depends_on = [
    aws_instance.bastion
  ]

  source = "./modules/null-ansible"

  bastion              = aws_instance.bastion.public_ip
  bastion_ssh_key_path = var.ssh_key_path
  extra_arguments      = ["--extra-vars 'host=${aws_instance.bastion.private_ip}'"]
  host                 = aws_instance.backend.private_ip
  playbook             = "ansible/playbooks/keyscan.yml"
  ssh_key_path         = var.ssh_key_path
  ssh_user             = var.ssh_user
}
