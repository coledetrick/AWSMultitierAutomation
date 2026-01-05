output "alb_dns_name" {
  value = aws_lb.ALB01.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.postgres.address
}
