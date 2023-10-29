# Create an ALB
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = var.lb_type
  subnets            = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
  security_groups    = [aws_security_group.my_alb_security_group.id]

  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false
}

# Create a target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}
# Register targets with the target group
resource "aws_lb_target_group_attachment" "my_target_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_instance.id
  port             = 80
}

# Create a listener on port 80
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}