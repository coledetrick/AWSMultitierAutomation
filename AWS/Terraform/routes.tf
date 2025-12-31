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

# Associations
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
