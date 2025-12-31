resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "automated-VPC"
  }
}

resource "aws_subnet" "PublicSubnet01AZ01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-west-2c"

  tags = {
    Name = "PublicSubnet01AZ01"
  }
}

resource "aws_subnet" "PrivateSubnet01AZ01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-west-2c"

  tags = {
    Name = "PrivateSubnet01AZ01"
  }
}

resource "aws_subnet" "PublicSubnet01AZ02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "us-west-2d"

  tags = {
    Name = "PublicSubnet01AZ02"
  }
}

resource "aws_subnet" "PrivateSubnet01AZ02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.48/28"
  availability_zone = "us-west-2d"

  tags = {
    Name = "PrivateSubnet01AZ02"
  }
}
