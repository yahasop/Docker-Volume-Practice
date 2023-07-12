terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair"
  provisioner "local-exec" {
    command = "chmod 400 ./tf-key-pair"
  }
}

resource "aws_vpc" "vpc_yamil" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc_yamil.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-security-group"
  }
}

resource "aws_subnet" "subnet_yamil" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.vpc_yamil.id
}

resource "aws_s3_bucket" "bucket-yamil" {
  bucket = "bucket-yamil-07112023"
  tags = {
    Name        = "bucket-yamil"
    Environment = "Dev"
  }
}

resource "aws_instance" "yamil-server" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_yamil.id
  key_name               = "tf-key-pair"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "yamil-server"
  }
  depends_on = [local_file.tf-key, aws_security_group.ec2_sg, aws_vpc.vpc_yamil]
}
/*
resource "aws_sns_topic" "yamil-sns-topic" {
  name = "yamil-sns-topic"
}
*/
