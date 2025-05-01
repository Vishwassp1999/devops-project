provider "aws" {
  region = "ap-south-1"
}

# Generate a unique ID for the SG name
resource "random_id" "suffix" {
  byte_length = 4
}

# Use the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Replace this with your valid subnet ID in ap-south-1
variable "subnet_id" {
  default = "subnet-04d352eb15fe690c9"
}

# Security group with unique name
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-allow-http-ssh-${random_id.suffix.hex}"
  description = "Allow HTTP and SSH"
  vpc_id      = "vpc-0782413ddc469e41c"

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

  tags = {
    Name = "nginx-sg"
  }
}

# EC2 Instance with Nginx installed via Docker
resource "aws_instance" "nginx_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = "terraform-key"  # Replace with actual key pair name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              docker run -d -p 80:80 --name webserver nginx
              EOF

  tags = {
    Name = "Terraform-python-server"
  }
}

output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.nginx_server.public_ip
}
