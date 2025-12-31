data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
  vpc_id            = aws_vpc.main.id
  availability_mode = "regional"
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

resource "aws_route_table" "PublicRouteTable01" {
  vpc_id = aws_vpc.example.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "PublicRouteTable01"
  }
}

resource "aws_route_table" "PrivateRouteTable01" {
  vpc_id = aws_vpc.example.id

  route = {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "PrivateRouteTable01"
  }
}
