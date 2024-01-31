# Instance that will host the web application
resource "aws_instance" "webserver_dev" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.webserver_key.key_name


  network_interface {
    network_interface_id = aws_network_interface.ws_dev_nic.id
    device_index         = 0
  }


  tags = {
    Name = "Simple Web Application"
  }
}

resource "aws_key_pair" "webserver_key" {
  key_name   = "deployer-key"
  public_key = file("./webserver_dev.pub")
}

#Network configs

resource "aws_vpc" "dev_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "development vpc"
  }
}

resource "aws_subnet" "dev_sb_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "development subnet 01"
  }
}

resource "aws_network_interface" "ws_dev_nic" {
  subnet_id       = aws_subnet.dev_sb_1.id
  private_ips     = ["172.16.10.100"]
  security_groups = [aws_security_group.ws_dev_sg.id]

  tags = {
    Name = "web_server_nic"
  }
}

resource "aws_security_group" "ws_dev_sg" {
  name        = "dev_webserver"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_inbound" {
  security_group_id = aws_security_group.ws_dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_inbound" {
  security_group_id = aws_security_group.ws_dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ws_dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = "dev_rt"
  }
}

resource "aws_route_table_association" "dev_rta" {
  subnet_id      = aws_subnet.dev_sb_1.id
  route_table_id = aws_route_table.dev_rt.id
}



