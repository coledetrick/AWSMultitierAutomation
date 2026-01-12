resource "aws_security_group" "albsg01" {
  name        = "albsg01"
  description = "ALB security group."
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "albsg01" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.albsg01.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.albsg01.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.albsg01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "asgsg01" {
  name        = "asgsg01"
  description = "ASG security group."
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "asgsg01" })
}

resource "aws_vpc_security_group_ingress_rule" "asg_http_from_alb" {
  security_group_id            = aws_security_group.asgsg01.id
  referenced_security_group_id = aws_security_group.albsg01.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "asg_https_from_alb" {
  security_group_id            = aws_security_group.asgsg01.id
  referenced_security_group_id = aws_security_group.albsg01.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "asg_all" {
  security_group_id = aws_security_group.asgsg01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "dbsg01" {
  name        = "dbsg01"
  description = "DB security group."
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "dbsg01" })
}

resource "aws_vpc_security_group_ingress_rule" "db_postgres_from_asg" {
  security_group_id            = aws_security_group.dbsg01.id
  referenced_security_group_id = aws_security_group.asgsg01.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db_all" {
  security_group_id = aws_security_group.dbsg01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
