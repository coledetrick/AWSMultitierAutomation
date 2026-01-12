resource "aws_lb_target_group" "tg01" {
  name     = "tg01"
  port     = 80
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

resource "aws_lb" "alb01" {
  name               = "alb01"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg01.id]
  subnets            = values(aws_subnet.public)[*].id
  internal           = false
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb01.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg01.arn
  }
}

resource "aws_launch_template" "lt01" {
  name_prefix   = "lt01"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.asgsg01.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_host = aws_db_instance.postgres.address
  }))
}

resource "aws_autoscaling_group" "asg01" {
  name                = "asg01"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 3
  vpc_zone_identifier = values(aws_subnet.private)[*].id

  launch_template {
    id      = aws_launch_template.lt01.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg01.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "asg01"
    propagate_at_launch = true
  }
}
