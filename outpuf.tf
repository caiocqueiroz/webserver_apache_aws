output "webserver_ip" {
  value = aws_instance.webserver_dev.public_ip
}

output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}

output "rt_id" {
  value = aws_route_table.dev_rt.id
}

output "cidr_block" {
  value = aws_vpc.dev_vpc.cidr_block
  
}