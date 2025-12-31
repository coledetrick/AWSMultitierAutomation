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
