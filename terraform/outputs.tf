output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}

output "database_instance_id" {
  value = aws_instance.database.id
}

output "database_private_ip" {
  value = aws_instance.database.private_ip
}

output "web_public_dns" {
  value = aws_instance.web.public_dns
}