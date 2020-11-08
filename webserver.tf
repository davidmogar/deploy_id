resource "aws_security_group" "webserver" {
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
  ami                    = var.ami[var.region]
  instance_type          = var.instance
  key_name               = "pix4d"
  vpc_security_group_ids = [aws_security_group.webserver.id]
}

module "null_ansible" {
  source = "./modules/null-ansible"

  extra_arguments = ["--extra-vars 'website_repository=${var.website_repository}'"]
  host            = aws_instance.webserver.public_ip
  playbook        = "ansible/playbooks/webserver.yml"
  ssh_key_path    = var.ssh_key_path
  ssh_user        = var.ssh_user
}
