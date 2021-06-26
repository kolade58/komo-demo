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
resource "aws_subnet" "public-main-us-east-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
     Name = "public-main subnet us-east-1a"

  }
}
resource "aws_subnet" "public-main_us_east_1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet main.us-east-1b"
  }
}
resource "aws_subnet" "private-main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"

  tags = {
    Name = "private-subnet.Main"
  }
}
