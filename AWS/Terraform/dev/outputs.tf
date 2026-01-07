output "postgres_endpoint" {
  value = aws_db_instance.postgres.address
}

output "alb_dns_name" {
  value = aws_lb.alb01.dns_name
}
