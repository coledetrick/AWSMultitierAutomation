data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
  vpc_id            = aws_vpc.main.id
  availability_mode = "regional"
}


resource "aws_subnet" "PublicSubnet01AZ01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-west-2c"

  tags = {
    Name = "PublicSubnet01AZ01"
  }
}

resource "aws_subnet" "PrivateSubnet01AZ01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-west-2c"

  tags = {
    Name = "PrivateSubnet01AZ01"
  }
}

resource "aws_subnet" "PublicSubnet01AZ02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "us-west-2d"

  tags = {
    Name = "PublicSubnet01AZ02"
  }
}

resource "aws_subnet" "PrivateSubnet01AZ02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.48/28"
  availability_zone = "us-west-2d"

  tags = {
    Name = "PrivateSubnet01AZ02"
  }
}

resource "aws_route_table" "PublicRouteTable01" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "PublicRouteTable01"
  }
}

resource "aws_route_table" "PrivateRouteTable01" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "PrivateRouteTable01"
  }
}

resource "aws_route_table_association" "PubSub01AZ01Assoc" {
  subnet_id      = aws_subnet.PublicSubnet01AZ01.id
  route_table_id = aws_route_table.PublicRouteTable01.id
}

resource "aws_route_table_association" "PubSub01AZ02Assoc" {
  subnet_id      = aws_subnet.PublicSubnet01AZ02.id
  route_table_id = aws_route_table.PublicRouteTable01.id
}

resource "aws_route_table_association" "PrivSub01AZ01Assoc" {
  subnet_id      = aws_subnet.PrivateSubnet01AZ01.id
  route_table_id = aws_route_table.PrivateRouteTable01.id
}

resource "aws_route_table_association" "PrivSub01AZ02Assoc" {
  subnet_id      = aws_subnet.PrivateSubnet01AZ02.id
  route_table_id = aws_route_table.PrivateRouteTable01.id
}
# Finish out security groups, test the networking deployment and then start working on the scripts for the actual infrastructure deployments.



resource "aws_security_group" "ALBSG01" {
  name        = "ALBSG01"
  description = "ALB security group."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ALBSG01"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_traffic_ipv4" {
  security_group_id = aws_security_group.ALBSG01.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "80"
  ip_protocol       = "tcp" 
  to_port           = "80"
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTPS_traffic_ipv4" {
  security_group_id = aws_security_group.ALBSG01.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "443"
  ip_protocol       = "tcp" 
  to_port           = "443"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ALBSG01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_security_group" "ASGSG01" {
  name        = "ASGSG01"
  description = "ASG security group."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ASGSG01"
  }
}

resource "aws_security_group_ingress_rule" "allow_http_from_web" {
  security_group_id        = aws_security_group.ASGSG01.id  
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ALBSG01.id
}

resource "aws_security_group_ingress_rule" "allow_http_from_web" {
  security_group_id        = aws_security_group.ASGSG01.id  
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ALBSG01.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ASGSG01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}



resource "aws_security_group_ingress_rule" "allow_PostreSQL_from_ASG" {
  security_group_id        = aws_security_group.DBSG01.id  
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ASGSG01.id
}

resource "aws_security_group" "DBSG01" {
  name        = "DBSG01"
  description = "DB security group."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "DBSG01"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.DBSG01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_lb_target_group" "TG01" {
  name     = "TG01"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "ALB01" {
  name               = "ALB01"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALBSG01.id]
  subnets            = [aws_subnet.PublicSubnet01AZ02.id, aws_subnet.PublicSubnet01AZ01.id]

  internal = false
}
