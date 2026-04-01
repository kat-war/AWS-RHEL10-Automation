provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "web_sg" {
  name        = "rhel-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rhel_server" {
  count         = 3
  ami           = "ami-0a951f007be151ff9" 
  instance_type = "t3.micro"            
  key_name      = "my-rhel-key"         

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "RHEL-Server-${count.index}"
  }
}

output "instance_ips" {
  value = aws_instance.rhel_server[*].public_ip
}