output "autoscaling_group" {
  value       = try(aws_autoscaling_group.this.0, null)
  description = "Autoscaling group"
}

output "loadbalancer_dns_name" {
  value       = try(aws_elb.this.0.dns_name, null)
  description = "DNS name of the ELB"
}

output "private_ip" {
  value       = try(aws_instance.this.0.private_ip, null)
  description = "Private IP of the AWS instance"
}

output "public_ip" {
  value       = try(aws_instance.this.0.public_ip, null)
  description = "Public IP of the AWS instance"
}

output "security_group" {
  value       = aws_security_group.this
  description = "Security group resource"
}
