##security Group
resource "aws_security_group" "alb-security-group" {
  name        = "ALB security group"
  description = "Enable HTTP/HTTPS access on port 443/80"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTPS Acess"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.10.0.0/16"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.10.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB security group"
  }
}
resource "aws_security_group" "ssh-sg" {
  name        = "SSH Access"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}
## Creating Security Group for web Server 
resource "aws_security_group" "Webserver-sg" {
  name        = "webserver Security Group"
  description = "Enable HTTPS/HTTP access on port 443/80 via ALB and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.alb-security-group.id}"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.alb-security-group.id}"]  

  }
    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.ssh-sg.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver sg"
  }
}
## Create security Group for Database
resource "aws_security_group" "Database-security_group" {
  name        = "Database Security Group"
  description = "Enable Database access on port 3306"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "RDS Access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.Webserver-sg.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
    tags    = {
       Name = "Database Security Groups"
    }
}
