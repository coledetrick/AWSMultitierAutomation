resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = { Name = each.value.name }
}
