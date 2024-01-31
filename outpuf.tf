output "webserver_ip" {
  value = aws_instance.webserver_dev.public_ip
}

output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}