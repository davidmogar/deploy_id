locals {
  security_groups = concat([aws_security_group.this.id],
    [
      for security_group in var.extra_security_groups :
      security_group.id
    ]
  )
}

resource "aws_security_group" "this" {
  depends_on = [
    var.subnet
  ]

  description = var.description
  name        = var.name
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
      cidr_blocks     = try(ingress.value.cidr_blocks, [])
      from_port       = ingress.value.port
      protocol        = "tcp"
      security_groups = try(ingress.value.security_groups, [])
      to_port         = ingress.value.port
    }
  }
}

resource "aws_instance" "this" {
  count = var.loadbalancer == null ? 1 : 0

  depends_on = [
    var.vpc,
  ]

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "deploy_it"
  subnet_id              = var.subnet.id
  user_data              = var.user_data
  vpc_security_group_ids = local.security_groups

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lb_security_group" {
  count = var.loadbalancer != null ? 1 : 0

  depends_on = [
    var.subnet
  ]

  description = "LB security group"
  name        = "lb"
  vpc_id      = var.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  dynamic "ingress" {
    for_each = var.loadbalancer.listeners
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value.lb_port
      protocol    = "tcp"
      to_port     = ingress.value.lb_port
    }
  }
}

resource "aws_elb" "this" {
  count = var.loadbalancer != null ? 1 : 0

  name            = var.name
  subnets         = [var.subnet.id]
  security_groups = [aws_security_group.lb_security_group.0.id]

  dynamic "listener" {
    for_each = var.loadbalancer.listeners
    content {
      instance_port      = try(listener.value.instance_port, listener.value.lb_port)
      instance_protocol  = try(listener.value.instance_protocol, listener.value.lb_protocol)
      lb_port            = listener.value.lb_port
      lb_protocol        = listener.value.lb_protocol
      ssl_certificate_id = try(listener.value.ssl_certificate_id, null)
    }
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_launch_template" "this" {
  count = var.loadbalancer != null ? 1 : 0

  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = "deploy_it"
  name_prefix            = var.name
  user_data              = var.user_data
  vpc_security_group_ids = local.security_groups

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  count = var.loadbalancer != null ? 1 : 0

  desired_capacity    = var.loadbalancer.desired_capacity
  max_size            = var.loadbalancer.max_size
  min_size            = var.loadbalancer.min_size
  vpc_zone_identifier = [var.subnet.id]

  launch_template {
    id      = aws_launch_template.this.0.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "this" {
  count = var.loadbalancer != null ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.this.0.id
  elb                    = aws_elb.this.0.id
}
