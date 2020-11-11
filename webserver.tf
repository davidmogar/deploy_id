module "webserver" {
  source = "./modules/instance"

  ami = var.ami[var.region]
  ingresses = [
    { "cidr_blocks" = [], "port" = 22, "security_groups" = [module.bastion.security_group.id] },
    { "cidr_blocks" = ["0.0.0.0/0"], "port" = 80, "security_groups" = [] },
    { "cidr_blocks" = ["0.0.0.0/0"], "port" = 443, "security_groups" = [] }
  ]
  instance_type  = var.instance
  description = "Allow traffic to http and ssh ports"
  name        = "webserver"
  subnet         = aws_subnet.public
  vpc            = aws_vpc.main
}

resource "null_resource" "webserver" {
  depends_on = [
    module.webserver
  ]

  connection {
    bastion_host        = module.bastion.public_ip
    bastion_private_key = file(var.ssh_key_path)
    host                = module.webserver.private_ip
    private_key         = file(var.ssh_key_path)
    type                = "ssh"
    user                = var.ssh_user
  }

  provisioner "file" {
    content     = acme_certificate.webserver.certificate_pem
    destination = "/home/${var.ssh_user}/${acme_certificate.webserver.certificate_domain}.pem"
  }

  provisioner "file" {
    content     = acme_certificate.webserver.private_key_pem
    destination = "/home/${var.ssh_user}/${acme_certificate.webserver.certificate_domain}_key.pem"
  }

  provisioner "file" {
    content     = cloudflare_origin_ca_certificate.webserver.certificate
    destination = "/home/${var.ssh_user}/cloudflare.crt"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/${var.ssh_user}/${acme_certificate.webserver.certificate_domain}.pem",
      "chmod 400 /home/${var.ssh_user}/${acme_certificate.webserver.certificate_domain}_key.pem",
      "chmod 400 /home/${var.ssh_user}/cloudflare.crt",
      "sudo mv /home/${var.ssh_user}/${acme_certificate.webserver.certificate_domain}*.pem /etc/ssh",
      "sudo mv /home/${var.ssh_user}/cloudflare.crt /etc/ssl/certs"
    ]
  }
}

module "nginx" {
  depends_on = [
    module.webserver,
    null_resource.webserver
  ]

  source = "./modules/ansible"

  bastion              = module.bastion.public_ip
  bastion_ssh_key_path = var.ssh_key_path
  extra_arguments      = ["--extra-vars 'domain=${acme_certificate.webserver.certificate_domain} website_repository=${var.website_repository}'"]
  host                 = module.webserver.private_ip
  playbook             = "ansible/playbooks/nginx/nginx.yml"
  ssh_key_path         = var.ssh_key_path
  ssh_user             = var.ssh_user
}
