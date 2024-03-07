# Free tier included resources
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

# EC2 image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "http" "localip" {
  url = "https://api.ipify.org"
}

# Create a VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "terraform-subnet" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create a security group
resource "aws_security_group" "terraform-sg" {
  description = "Terraform Managed Security Group"
  vpc_id      = aws_vpc.terraform-vpc.id
  ingress {
    description = "Allow only SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.localip.response_body}/32"]
  }
  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "terraform-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.terraform-subnet.id
  key_name                    = var.AWS_SSH_KEY_NAME
  vpc_security_group_ids      = [aws_security_group.terraform-sg.id]
  associate_public_ip_address = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "TerraformEC2"
  }
}

# Create a subnet group for the RDS instance
resource "aws_db_subnet_group" "terraform-rds-snet-grp" {
  name       = "terraform-rds-snet-grp"
  subnet_ids = [aws_subnet.terraform-subnet.id]
}

# Create the RDS instance
resource "aws_db_instance" "terraform-rds" {
  allocated_storage       = 20
  instance_class          = "db.t2.micro"
  engine                  = "mysql"
  db_name                 = "terraformrds"
  username                = var.RDS_USERNAME
  password                = var.RDS_PASSWORD
  skip_final_snapshot     = true
  backup_retention_period = 7
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.terraform-rds-snet-grp.name
  vpc_security_group_ids  = [aws_security_group.terraform-sg.id]
}
