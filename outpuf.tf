output "webserver_ip" {
    value = aws_instance.webserver_dev.public_ip
}