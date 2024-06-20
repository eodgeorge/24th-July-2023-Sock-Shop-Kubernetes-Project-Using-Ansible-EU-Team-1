output "Haproxy_private_ip" {
  value = aws_instance.haproxy.private_ip
}

output "Haproxybkup_private_ip" {
  value = aws_instance.haproxy-bckup.private_ip
}