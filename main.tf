provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "myvm" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 (ap-south-1)
  instance_type = "t2.micro"
  key_name      = "terraform-key"  # Replace with an existing EC2 key pair

  vpc_security_group_ids = [aws_security_group.mysec.id]

  tags = {
    Name = "Jenkins-EC2"
  }
}

resource "aws_security_group" "mysec" {
  name        = "jenkins-sg"
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

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.myvm.public_ip
}

