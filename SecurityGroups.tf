# Security Group Configuration
resource "aws_security_group" "my_web_security_group" {
  name        = var.security_group_name
  description = "Security group for the EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #replace security_groups = [aws_security_group.my_web_security_group.id]
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "SSH from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.my_alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# RDS Security Group Configuration
resource "aws_security_group" "my_rds_security_group" {
  name        = var.security_group_db_name
  description = "Security group for the RDS instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "EC2 to RDS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.my_web_security_group.id]
  }

  # Define egress rules based on var.egress_rules
  dynamic "egress" {
    for_each = var.sg_ports_db
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
#ALB security group 
resource "aws_security_group" "my_alb_security_group" {
  name        = var.security_group_name_alb
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.sg_ports_alb
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#EFS security group 
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Allos inbound efs traffic from ec2"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    security_groups = [aws_security_group.my_web_security_group.id, aws_security_group.my_rds_security_group.id]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  egress {
    security_groups = [aws_security_group.my_web_security_group.id, aws_security_group.my_rds_security_group.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
}