provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "server-deployment-001" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"


}

// 1. Create vpc
resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "prod-vpc"
  }
}

// 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first-vpc.id

  tags = {
    Name = "internet-gw"
  }
}

// 3. Create Custom Route table
resource "aws_route_table" "prod-route-tab" {
  vpc_id = aws_vpc.first-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod-route-tab"
  }
}


// 4. Create a subnet
resource "aws_subnet" "subnet-01" {
  vpc_id            = aws_vpc.first-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}



//5. Associate subnet with Route Table
resource "aws_route_table_association" "assoc-route-tab" {
  subnet_id      = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.prod-route-tab.id
}


//6. Create Security Group to allocate port 20, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web traffic"
  vpc_id      = aws_vpc.first-vpc.id

  // This allows inbound rules
  ingress {
    description = "HTTPS Traffic from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    // Our work id
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.first-vpc.ipv6_cidr_block]
  }


  ingress {
    description = "HTTPS Traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    // Our work id
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.first-vpc.ipv6_cidr_block]
  }

  ingress {
    description = "HTTPS Traffic from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // Our work id
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.first-vpc.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}



//7. Create a network interface with sn ip in the subner that was created in step 4


//8. Assign an elastic IP to the network created in step 7


//9. Create Ubuntu server and install/enable apache2
