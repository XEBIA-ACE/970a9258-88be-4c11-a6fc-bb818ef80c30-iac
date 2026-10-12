resource "aws_kms_key" "eks" {
  description             = "KMS key for encrypting EKS secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-eks-kms"
  })
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.environment}-eks-cluster"
  target_key_id = aws_kms_key.eks.key_id
}