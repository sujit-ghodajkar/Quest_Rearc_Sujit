resource "aws_security_group" "rearc_app_sg" {
  name   = "rearc-app-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "rearc_app_lb" {
  name               = "rearc-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rearc_app_sg.id]
  subnets            = module.vpc.subnet_ids
}

resource "aws_lb_target_group" "rearc_app_tg" {
  name     = "rearc-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "rearc_app_listener" {
  load_balancer_arn = aws_lb.rearc_app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rearc_app_tg.arn
  }
}
