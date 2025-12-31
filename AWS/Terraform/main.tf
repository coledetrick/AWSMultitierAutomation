terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # Your exact subnet plan
  subnets = {
    private_az01 = { cidr = "10.0.0.0/28",  az = local.azs[0], public = false, name = "PrivateSubnet01AZ01" }
    public_az01  = { cidr = "10.0.0.16/28", az = local.azs[0], public = true,  name = "PublicSubnet01AZ01" }
    private_az02 = { cidr = "10.0.0.32/28", az = local.azs[1], public = false, name = "PrivateSubnet01AZ02" }
    public_az02  = { cidr = "10.0.0.48/28", az = local.azs[1], public = true,  name = "PublicSubnet01AZ02" }
  }
}

# --------------------
# VPC
# --------------------
resource "aws_vpc" "vpc01" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "VPC01" }
}

# --------------------
# Subnets
# --------------------
resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = { Name = each.value.name }
}

# --------------------
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc01.id
  tags   = { Name = "VPC01-IGW" }
}

# --------------------
# NAT Gateway (Regional) - placed in a PUBLIC subnet (AZ01 here)
# --------------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "VPC01-NAT-EIP" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets["public_az01"].id

  depends_on = [aws_internet_gateway.igw]

  tags = { Name = "VPC01-NATGW" }
}

# --------------------
# Route Tables
# --------------------
# Public route table: default route to IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc01.id
  tags   = { Name = "RouteTable-Public" }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Private route table: default route to NAT GW
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc01.id
  tags   = { Name = "RouteTable-Private" }
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# --------------------
# Route Table Associations
# --------------------
resource "aws_route_table_association" "public_az01" {
  subnet_id      = aws_subnet.subnets["public_az01"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az02" {
  subnet_id      = aws_subnet.subnets["public_az02"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_az01" {
  subnet_id      = aws_subnet.subnets["private_az01"].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az02" {
  subnet_id      = aws_subnet.subnets["private_az02"].id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  value = aws_vpc.vpc01.id
}

output "subnet_ids" {
  value = { for k, s in aws_subnet.subnets : k => s.id }
}
