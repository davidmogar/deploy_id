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
