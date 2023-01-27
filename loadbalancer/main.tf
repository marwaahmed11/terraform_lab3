# target group
resource "aws_lb_target_group" "alb-tg" {
  name     = var.alb-tg-name 
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  target_type = "instance"

  health_check {
    path = "/"
    port = 80
  }
}

# alb security group 
resource "aws_security_group" "alb" {
  name        = var.security-group-lb-name 
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# alb
resource "aws_lb" "alb" {
  name            = var.alb-name
  internal           = false  # internet facing 
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id] #################name wla id
#   vpc_security_group_ids = [aws_security_group.alb.id]
  subnets         = [var.public-subnet-id-1,var.public-subnet-id-2]

}

# alb listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

# attach ec2 to tg
resource "aws_lb_target_group_attachment" "tg-attach" {
  count = length(var.public-instance-ids)
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = var.public-instance-ids[count.index]

}


#### private load balancer 

# target group 
resource "aws_lb_target_group" "alb-tg-2" {
  name     = var.private-alb-tg-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  target_type = "instance"

  health_check {
    path = "/"
    port = 80
  }
}

# app load balancer private
resource "aws_lb" "alb-2" {
  name            = var.private-alb-name
  internal           = true # private
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id] #################name wla id
#   vpc_security_group_ids = [aws_security_group.alb.id]
  subnets         =  [var.private-subnet-id-1,var.private-subnet-id-2]

}

# alb listener
resource "aws_lb_listener" "alb-listener-2" {
  load_balancer_arn = aws_lb.alb-2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-2.arn
  }
}

# attach ec2 to tg
resource "aws_lb_target_group_attachment" "tg-attach-2" {
  count = length(var.private-instance-ids)
  target_group_arn = aws_lb_target_group.alb-tg-2.arn
  target_id        = var.private-instance-ids[count.index]

}


