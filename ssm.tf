# Define the IAM role for the EC2 instance
resource "aws_iam_role" "ssm_instance_role" {
  name = "ssm-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Define the IAM policy that grants SSM permissions
resource "aws_iam_policy" "ssm_instance_policy" {
  name        = "ssm-instance-policy"
  description = "IAM policy for SSM access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "ssm_instance_policy_attachment" {
  name       = "ssm-instance-policy-attachment" # Add a unique name here
  policy_arn = aws_iam_policy.ssm_instance_policy.arn
  roles      = [aws_iam_role.ssm_instance_role.name]
}

# Define the EC2 instance profile with the IAM role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_instance_role.name
}

