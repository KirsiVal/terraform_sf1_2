# CloudWatch Metric Alarm Configuration
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = var.cloudwatch_alarm_name
  comparison_operator = var.cloudwatch_comparison_operator
  evaluation_periods  = var.cloudwatch_evaluation_periods
  metric_name         = var.cloudwatch_metric_name
  namespace           = var.cloudwatch_namespace
  period              = var.cloudwatch_period
  statistic           = var.cloudwatch_statistic
  threshold           = var.cloudwatch_threshold
  alarm_description   = var.cloudwatch_alarm_description
  alarm_actions       = [aws_sns_topic.my_sns_topic.arn]
  dimensions = {
    LoadBalancer = aws_lb.my_alb.id
  }
}

# SNS Topic Configuration
resource "aws_sns_topic" "my_sns_topic" {
  name = var.sns_topic_name
}

# SNS Subscription Configuration
resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint_email
}

# Policy to allow SNS to publish to the CloudWatch alarm
resource "aws_iam_policy" "sns_policy" {
  name   = "sns-publish-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.my_sns_topic.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "sns_role" {
  name = "MySNSTopicRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com" # This allows the SNS service to assume the role
        }
      }
    ]
  })
}

