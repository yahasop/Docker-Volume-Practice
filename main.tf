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

resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

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

resource "aws_s3_bucket" "bucket-yamil" {
  bucket = "bucket-yamil-06212023"
  tags = {
    Name        = "bucket-yamil"
    Environment = "Dev"
  }
}

resource "aws_instance" "yamil-server" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t3.micro"
  key_name      = "tf-key-pair"
  //security_groups = [ aws_security_group.ec2_sg.id ]
  tags = {
    Name = "yamil-server"
  }
  depends_on = [local_file.tf-key, aws_security_group.ec2_sg]
}

resource "aws_sns_topic" "yamil-sns-topic" {
  name = "yamil-sns-topic"
}
