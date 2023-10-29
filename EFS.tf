# EFS Configuration
resource "aws_efs_file_system" "my_efs" {
  creation_token   = var.efs_creation_token
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode
  encrypted        = var.efs_encrypted
  tags = {
    Name = "my-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(aws_subnet.private_subnet)
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = aws_subnet.private_subnet[count.index].id
  security_groups = [aws_security_group.efs.id]
}