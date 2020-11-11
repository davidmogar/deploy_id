module "webserver" {
  source = "./modules/instance"

  ami         = var.ami["nginx"]
  description = "Allow traffic to http and ssh ports"
  ingresses = [
    {
      "cidr_blocks" = ["0.0.0.0/0"],
      "port"        = 80
    }
  ]
  instance_type = var.instance
  loadbalancer = {
    "availability_zones" = ["${var.region}a", "${var.region}b"]
    "desired_capacity"   = 1
    "listeners" = [
      {
        "instance_port"      = 80,
        "instance_protocol"  = "http",
        "lb_port"            = 443,
        "lb_protocol"        = "https",
        "ssl_certificate_id" = aws_acm_certificate_validation.cert.certificate_arn
      }
    ]
    "max_size" = 3
    "min_size" = 1
  }
  name   = "webserver"
  subnet = aws_subnet.public
  user_data = base64encode(templatefile("templates/webserver_user_data.tpl",
    {
      website_repository = var.website_repository
    }
  ))
  vpc = aws_vpc.main
}
