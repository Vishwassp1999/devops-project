provider "aws" {
  region = "ap-south-1"
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

# Replace this with a valid subnet ID from your AWS account in ap-south-1
variable "subnet_id" {
  default = "subnet-04d352eb15fe690c9" # <-- Replace with actual subnet ID
}

# Security group
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-allow-http-ssh"
  description = "Allow HTTP and SSH"
  vpc_id      = "vpc-0782413ddc469e41c" # Optional: Only needed if not default VPC

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

# EC2 Instance with nginx installed via user_data
resource "aws_instance" "nginx_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = "terraform-key"  # Replace with actual key pair name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name = "Terraform-Nginx-EC2"
  }
}
