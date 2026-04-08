output "instance_ip" {
  value = aws_instance.ec2.public_ip
}

output "instance_dns" {
  value = aws_instance.ec2.public_dns
}