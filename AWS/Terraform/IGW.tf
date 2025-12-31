resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc01.id
  tags   = { Name = "VPC01-IGW" }
}
