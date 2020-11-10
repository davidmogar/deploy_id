module "webserver" {
  source = "./modules/instance"

  ami = var.ami[var.region]
  ingresses = [
    { "cidr_blocks" = [], "port" = 22, "security_groups" = [module.bastion.security_group.id] },
    { "cidr_blocks" = ["0.0.0.0/0"], "port" = 80, "security_groups" = [] }
  ]
  instance_type  = var.instance
  sg_description = "Allow traffic to http and ssh ports"
  sg_name        = "webserver"
  subnet         = aws_subnet.public
  vpc            = aws_vpc.main
}

module "nginx" {
  source = "./modules/ansible"

  bastion              = module.bastion.public_ip
  bastion_ssh_key_path = var.ssh_key_path
  extra_arguments      = ["--extra-vars 'website_repository=${var.website_repository}'"]
  host                 = module.webserver.private_ip
  playbook             = "ansible/playbooks/nginx/nginx.yml"
  ssh_key_path         = var.ssh_key_path
  ssh_user             = var.ssh_user
}
