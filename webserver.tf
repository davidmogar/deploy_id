resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Allow traffic to http and ssh ports"

  egress {
    cidr_blocks = var.sg_egress_cidr
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  dynamic "ingress" {
    for_each = [22, 80]
    content {
      cidr_blocks = var.sg_ingress_cidr
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
    }
  }
}

resource "aws_instance" "webserver" {
  ami                    = var.ami[var.region]
  instance_type          = var.instance
  key_name               = "pix4d"
  vpc_security_group_ids = [aws_security_group.webserver.id]
}

resource "aws_eip_association" "webserver" {
  allocation_id = aws_eip.webserver.id
  instance_id   = aws_instance.webserver.id
}

resource "aws_eip" "webserver" {}

module "null_ansible" {
  source = "./modules/null-ansible"

  extra_arguments = ["--extra-vars 'website_repository=${var.website_repository}'"]
  host            = aws_eip.webserver.public_ip
  playbook        = "ansible/playbooks/webserver.yml"
  ssh_key_path    = var.ssh_key_path
  ssh_user        = var.ssh_user
}
