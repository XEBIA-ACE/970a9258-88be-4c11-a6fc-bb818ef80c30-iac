resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30

  tags = merge(local.common_tags, {
    Name = "${var.environment}-eks-log-group"
  })
}

resource "aws_iam_role" "cluster_logging" {
  name = "${var.environment}-eks-cluster-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "cluster_logging" {
  name = "${var.environment}-eks-cluster-logging-policy"
  role = aws_iam_role.cluster_logging.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          aws_cloudwatch_log_group.eks.arn,
          "${aws_cloudwatch_log_group.eks.arn}:*"
        ]
      }
    ]
  })
}