# One EIP per NAT GW
resource "aws_eip" "nat" {
  for_each = {
    az01 = aws_subnet.subnets["public_az01"].id
    az02 = aws_subnet.subnets["public_az02"].id
  }

  domain = "vpc"

  tags = {
    Name = "VPC01-NAT-EIP-${each.key}"
  }
}

# One NAT GW per AZ (NAT must live in a PUBLIC subnet in that AZ)
resource "aws_nat_gateway" "nat" {
  for_each = {
    az01 = aws_subnet.subnets["public_az01"].id
    az02 = aws_subnet.subnets["public_az02"].id
  }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "VPC01-NATGW-${each.key}"
  }
}
