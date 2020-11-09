output "private_ip" {
  value       = aws_instance.this.private_ip
  description = "Private IP of the AWS instance"
}

output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "Public IP of the AWS instance"
}

output "security_group" {
  value       = aws_security_group.this
  description = "Security group resource"
}
