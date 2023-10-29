# RDS Instance Configuration
resource "aws_db_instance" "my_db" {
  allocated_storage      = var.rds_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  username               = var.rds_username
  password               = var.rds_password
  parameter_group_name   = var.rds_parameter_group_name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.my_rds_security_group.id]

  tags = {
    Name = "my-db"
  }

}