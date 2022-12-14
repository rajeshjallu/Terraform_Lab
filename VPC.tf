#AWS  Provider
provider "aws" {
  region = "us-west-1"
}
#create vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-demo"
  }
}
# to display output
data "aws_caller_identity" "current" {}

output "aws_caller_info" {
    value = data.aws_caller_identity.current
}

#to create Public Subnet
resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "public"
  }
}
#to create Private Subnet
resource "aws_subnet" "pri" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.3.0/24"
  tags = {
    Name = "private"
  }
}
#To create Inernet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}
# to create Elastic Ip for craeting NAT gateway
resource "aws_eip" "IP" {
  vpc      = true
}

#To create NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.IP.id
  subnet_id     = aws_subnet.pri.id

  tags = {
    Name = "NGW"
  }
}
#To create Route Table for Internetgateway
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "custom"
  }
}
##To create Route Table for NAT gateway
  resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "main"
  }
}

# subnet association with route tables
  resource "aws_route_table_association" "as_1" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt1.id
}
resource "aws_route_table_association" "as_2" {
  subnet_id      = aws_subnet.pri.id
  route_table_id = aws_route_table.rt2.id
}
#to Create Security Group
  resource "aws_security_group" "sg" {
  name        = "first-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "first-sg"
  }
}
