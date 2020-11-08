resource "aws_security_group" "webserver" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public
  ]

  name        = "webserver"
  description = "Allow traffic to http and ssh ports"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
}

resource "aws_instance" "webserver" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public,
    aws_security_group.bastion
  ]

  ami                    = var.ami[var.region]
  instance_type          = var.instance
  key_name               = "deploy_it"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webserver.id]
}

module "null_ansible" {
  source = "./modules/null-ansible"

  bastion              = aws_instance.bastion.public_ip
  bastion_ssh_key_path = var.ssh_key_path
  extra_arguments      = ["--extra-vars 'website_repository=${var.website_repository}'"]
  host                 = aws_instance.webserver.private_ip
  playbook             = "ansible/playbooks/nginx.yml"
  ssh_key_path         = var.ssh_key_path
  ssh_user             = var.ssh_user
}
