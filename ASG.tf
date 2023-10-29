##ASG 
resource "aws_launch_configuration" "my_launch_config" {
  name_prefix     = "my-launch-config"
  image_id        = var.instance_ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  user_data       = file("script.sh")
  security_groups = [aws_security_group.my_web_security_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.my_launch_config.name
  desired_capacity     = 1
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier  = [aws_subnet.private_subnet[0].id] # Specify the subnet(s) here

  # Add scaling policies as needed
}
resource "aws_autoscaling_policy" "my_scaling_policy" {
  name                   = "my-scaling-policy"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name

  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = 1
}