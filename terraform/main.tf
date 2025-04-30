provider "aws" {
  region = "ap-south-1"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get any default subnet in that default VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "default" {
  id = data.aws_subnet_ids.default.ids[0]
}

# Create security group
resource "aws_security_group" "mysec" {
  name        = "mysec"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

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
    Name = "Allow-SSH-HTTP"
  }
}

# Launch EC2
resource "aws_instance" "myvm" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.mysec.id]

  tags = {
    Name = "Jenkins-Terraform-EC2"
  }
}
