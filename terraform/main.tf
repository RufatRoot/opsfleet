# main.tf

# Configure provider
provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

# Create an EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "latest"
  vpc_config {
    subnet_ids         = ["subnet-12345678", "subnet-23456789"] # Replace with your subnet IDs
    security_group_ids = ["sg-12345678"] # Replace with your security group IDs
  }
}

# IAM role for the EKS cluster
resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM policy for pod access to S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "pod-s3-access-policy"
  description = "Allows pods to access S3 bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3Access",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "${aws_iam_role.cluster.arn}"
    }
  ]
}
EOF
}

# Attach IAM policy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.cluster.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}