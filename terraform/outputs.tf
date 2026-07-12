output "elastic_ip" {
  description = "Public IP to SSH into and browse to"
  value       = aws_eip.nginx_eip.public_ip
}

output "ssh_command" {
  description = "Ready-to-use SSH command"
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_eip.nginx_eip.public_ip}"
}
