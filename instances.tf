resource "aws_instance" "firewall_instance" {
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_dmz_subnet.id
  security_groups        = [aws_security_group.dmz_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "firewall-instance"
  }
}

resource "aws_instance" "server_instances" {
  count                  = 2
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_servers_subnet.id
  security_groups        = [aws_security_group.servers_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "server-instance-${count.index}"
  }
}

resource "aws_instance" "db_instances" {
  count                  = 2
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_db_subnet.id
  security_groups        = [aws_security_group.db_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "db-instance-${count.index}"
  }
}

