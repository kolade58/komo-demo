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
resource "aws_subnet" "private-main2" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.10.3.0/24" 
    tags = {
      Name = "private-subnet.Main2"
   }
 }
## Route Tables
resource "aws_route_table" "Route_table" {
  vpc_id = aws_vpc.main.id
  
   tags = {
    Name    = "Route_table"
  } 
} 
resource "aws_route_table" "route-table-priv" {
 vpc_id  = aws_vpc.main.id

  tags = {
   Name = "route-table-priv"
  }
}
## Route table association
resource "aws_route_table_association" "public-ass1" {
  subnet_id      = aws_subnet.public-main-us-east-1a.id
  route_table_id = aws_route_table.Route_table.id
}
resource "aws_route_table_association" "public-ass2" {
  subnet_id      = aws_subnet.public-main_us_east_1b.id
  route_table_id = aws_route_table.Route_table.id
}
resource "aws_route_table_association" "private-ass1" {
  subnet_id      = aws_subnet.private-main.id
  route_table_id = aws_route_table.route-table-priv.id
}
resource "aws_route_table_association" "private-ass2" {
   subnet_id      = aws_subnet.private-main2.id
   route_table_id = aws_route_table.route-table-priv.id
}
##Nat-gateway
resource "aws_eip" "eip-nat-gate1" {
  vpc      = true
  tags      = {
 Name      = "eip one"
 }   
}
resource "aws_eip" "eip-nat-gate2" {
  vpc      = true
  tags      = {
  Name     = "eip two"
 }
}
resource "aws_nat_gateway" "nat-gate1" {
  allocation_id = aws_eip.eip-nat-gate1.id
  subnet_id     = aws_subnet.private-main.id

  tags = {
    Name = "nat-gate1"
  }
}  
resource "aws_nat_gateway" "Nat2" {
  allocation_id = aws_eip.eip-nat-gate2.id
  subnet_id     = aws_subnet.private-main2.id

  tags = {
    Name = "nat-gate2"
  }
}
resource "aws_instance" "Webo1" {
  ami           				= "ami-0747bdcabd34c712a"
  instance_type 				= "t2.micro"
  availability_zone				= "us-east-1a"
  associate_public_ip_address	= "true"
  subnet_id						= aws_subnet.public-main-us-east-1a.id
  ##security_groups				= "aws_security_group.allow_HTTP.id"
  tags = {
    Name = "Webo1"
	Tier = "Web"
    Subnet = "Public"
  }
 }
resource "aws_instance" "Webo2" {
  ami           				= "ami-0747bdcabd34c712a"
  instance_type 				= "t2.micro"
  availability_zone				= "us-east-1b"
  associate_public_ip_address	= "true"
  subnet_id						= aws_subnet.public-main_us_east_1b.id 
  ##security_groups		= "aws_security_group.allow_HTTP.id"
    tags = {
    Name = "Webo2"
	  Tier = "Web"
    Subnet = "Public"
  }
 }
resource "aws_instance" "serv_app1" {
  ami           				= "ami-0747bdcabd34c712a"
  instance_type 				= "t2.micro"
  availability_zone				= "us-east-1e"
  subnet_id						= aws_subnet.private-main.id 
  ##security_groups				= "aws_security_group.allow_SSH.id"
  tags = {
    Name = "serv_app1"
	  Tier = "Application"
    Subnet = "Private"
  }
 }
resource "aws_instance" "serv_app2" {
  ami           				= "ami-0747bdcabd34c712a"
  instance_type 				= "t2.micro"
  availability_zone				= "us-east-1d"
  subnet_id						= aws_subnet.private-main2.id
  ##security_groups				= "aws_security_group.allow_SSH.id"
  tags = {
    Name = "serv_app2"
	Tier = "Application"
    Subnet = "Private"
  }
 }
##Security group

