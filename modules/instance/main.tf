resource "aws_security_group" "this" {
  depends_on = [
    var.subnet
  ]

  description = var.sg_description
  name        = var.sg_name
  vpc_id      = var.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  dynamic "ingress" {
    for_each = var.ingresses
    content {
      cidr_blocks     = ingress.value["cidr_blocks"]
      from_port       = ingress.value["port"]
      protocol        = "tcp"
      security_groups = ingress.value["security_groups"]
      to_port         = ingress.value["port"]
    }
  }
}

resource "aws_instance" "this" {
  depends_on = [
    var.vpc,
  ]

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "deploy_it"
  subnet_id     = var.subnet.id
  vpc_security_group_ids = concat([aws_security_group.this.id],
    [
      for security_group in var.extra_security_groups :
      security_group.id
    ]
  )
}
