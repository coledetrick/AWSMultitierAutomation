output "vpc_id" {
  value = aws_vpc.vpc01.id
}

output "subnet_ids" {
  value = { for k, s in aws_subnet.subnets : k => s.id }
}
