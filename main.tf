provider "aws" {
 region =  "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TF-vpc"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "TF-igw"
  }
}
resource "aws_subnet" "public-main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.0.0/24"

  tags = {
    Name = "public-main"
  }
}
resource "aws_subnet" "private-main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"

  tags = {
    Name = "private-subnet.Main"
  }
}

