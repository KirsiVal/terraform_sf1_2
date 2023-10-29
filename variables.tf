##Define variables for VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

##Define variables for Subnets

variable "countnum" {
  description = "CIDR blocks for private subnets"
  default     = "2"
}
variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}
###Define variables for SG ports
variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80]
}

variable "security_group_db_name" {
  description = "Name for the security group"
  default     = "my-db_sg"
}


variable "sg_ports_db" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [3306]
}
variable "security_group_name" {
  description = "Name for the security group"
  default     = "my-web_sg"
}
variable "security_group_name_alb" {
  description = "Name for the security group ALB"
  default     = "my-alb_sg"
}

variable "sg_ports_alb" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80]
}
#Define variables for EC2
variable "instance_ami" {
  description = "AMI for EC2"
  default     = "ami-0550c2ee59485be53"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "key for EC2"
  default     = "my-key-pair2"
}

# Define variables for RDS

variable "rds_allocated_storage" {
  type    = string
  default = "20"
}
variable "rds_engine" {
  type    = string
  default = "mysql"
}
variable "rds_engine_version" {
  type    = string
  default = "5.7"
}
variable "rds_instance_class" {
  type    = string
  default = "db.r5.large"
}

variable "rds_username" {
  type    = string
  default = "dbuser"
}
variable "rds_password" {
  type    = string
  default = "Paassw0rd123"
}
variable "rds_parameter_group_name" {
  type    = string
  default = "default.mysql5.7"
}

#Define variables for ALB

variable "lb_internal" {
  default = "false"
}

variable "listener_port" {
  default = "80"
}
variable "listener_protocol" {
  default = "HTTP"
}
variable "lb_type" {
  default = "application"
}
# Define variables for CloudWatch Metric Alarm Configuration

variable "cloudwatch_alarm_name" {
  default = "web-app-requests-alarm"
}
variable "cloudwatch_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_evaluation_periods" {
  default = "2"
}
variable "cloudwatch_metric_name" {
  default = "RequestCount"
}
variable "cloudwatch_namespace" {
  default = "AWS/ALB"
}

variable "cloudwatch_period" {
  default = "300" # 5 minutes
}
variable "cloudwatch_statistic" {
  default = "SampleCount"
}
variable "cloudwatch_threshold" {
  default = "1000"
}

variable "cloudwatch_alarm_description" {
  default = "Alarm for high request count in 10 minutes"
}


# Define variables for SNS Topic Configuration

variable "sns_topic_name" {
  default = "sns_topic"
}
variable "sns_endpoint_email" {
  default = "your-email@example.com"
}

#Define variables for EFS configuration

variable "efs_creation_token" {
  default = "my-efs"
}
variable "efs_performance_mode" {
  default = "generalPurpose"
}

variable "efs_throughput_mode" {
  default = "bursting"
}
variable "efs_encrypted" {
  default = "true"
}

# VPC Configuration
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
}



