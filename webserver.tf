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

resource "aws_autoscaling_policy" "instances_scale_up" {
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = module.webserver.autoscaling_group.name
  cooldown               = 300
  name                   = "instances_scale_up"
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "instances_scale_down" {
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = module.webserver.autoscaling_group.name
  cooldown               = 300
  name                   = "instances_scale_down"
  scaling_adjustment     = -1
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_actions = [
    aws_autoscaling_policy.instances_scale_up.arn
  ]
  alarm_description   = "Metric to monitor EC2 instnaces memory for high utilization"
  alarm_name          = "mem_util_high_instances"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    AutoScalingGroupName = module.webserver.autoscaling_group.name
  }
  evaluation_periods = "2"
  metric_name        = "MemoryUtilization"
  namespace          = "System/Linux"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  alarm_actions = [
    aws_autoscaling_policy.instances_scale_down.arn
  ]
  alarm_description   = "Metric to monitor EC2 instnaces memory for low utilization"
  alarm_name          = "mem_util_low_instances"
  comparison_operator = "LessThanOrEqualToThreshold"
  dimensions = {
    AutoScalingGroupName = module.webserver.autoscaling_group.name
  }
  evaluation_periods = "2"
  metric_name        = "MemoryUtilization"
  namespace          = "System/Linux"
  period             = "300"
  statistic          = "Average"
  threshold          = "40"
}
