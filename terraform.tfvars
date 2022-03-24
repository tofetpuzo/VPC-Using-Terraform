/* subnet-prefix = "10.0.1.0/24" */

subnet-prefix = ["10.0.1.0/24", "10.0.2.0/24"]

/* List of objects */
subnet-prefix1 = [{ cidr_block = ["10.0.1.0/24", "10.0.2.0/24"], name = "prod-subnet" }, { cidr_block = ["10.0.1.0/24", "10.0.2.0/24"], name = "prod-subnet-2" }]

resource "aws_subnet" "subnet-01" {
  vpc_id            = aws_vpc.first-vpc.id
  cidr_block        = var.subnet-prefix[0].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[0].name
  }
}

resource "aws_subnet" "subnet-02" {
  vpc_id            = aws_vpc.first-vpc.id
  cidr_block        = var.subnet-prefix[1].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[1].name
  }
}


/* terraform apply -var-file example.tfvars */
