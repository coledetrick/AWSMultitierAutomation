resource "aws_db_subnet_group" "db_subnets" {
  name       = "db_subnets"
  subnet_ids = concat(values(aws_subnet.private)[*].id, values(aws_subnet.public)[*].id)
  tags       = merge(local.common_tags, { Name = "db_subnets" })
}

resource "aws_db_instance" "postgres" {
  identifier = "db01"

  engine         = "postgres"
  engine_version = "17.6"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.dbsg01.id]

  publicly_accessible = false

  skip_final_snapshot = true
  deletion_protection = false

  backup_retention_period = 1
  multi_az                = false

  tags = merge(local.common_tags, { Name = "db01" })
}
