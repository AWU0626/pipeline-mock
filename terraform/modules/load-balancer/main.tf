# configure security group for alb
resource "aws_security_group" "alb_sg" {
  name   = "auth-service-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

# configure application load balancer
resource "aws_lb" "auth_alb" {
  name               = "auth-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids
}

# configure target group
resource "aws_lb_target_group" "auth_tg" {
  name     = "auth-service-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# attach ec2 instance to target group
resource "aws_lb_target_group_attachment" "auth_tg_attachment" {
  target_group_arn = aws_lb_target_group.auth_tg.arn
  target_id        = var.ec2_instance_id
  port             = 8080
}

# configure listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.auth_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn
  }
}
