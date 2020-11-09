module "backend" {
  depends_on = [
    module.bastion
  ]

  source = "./modules/instance"

  ami                   = var.ami[var.region]
  extra_security_groups = [module.bastion.security_group]
  ingresses = [
    { "cidr_blocks" = [], "port" = 22, "security_groups" = [module.bastion.security_group.id] }
  ]
  instance_type  = var.instance
  sg_description = "Allow traffic to ssh port"
  sg_name        = "backend"
  subnet         = aws_subnet.private
  vpc            = aws_vpc.main
}

module "keyscan" {
  source = "./modules/ansible"

  bastion              = module.bastion.public_ip
  bastion_ssh_key_path = var.ssh_key_path
  extra_arguments      = ["--extra-vars 'host=${module.bastion.private_ip}'"]
  host                 = module.backend.private_ip
  playbook             = "ansible/playbooks/keyscan.yml"
  ssh_key_path         = var.ssh_key_path
  ssh_user             = var.ssh_user
}
