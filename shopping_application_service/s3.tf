```hcl
resource "aws_s3_bucket" "shopping_app_bucket" {
  bucket = "shopping-app-bucket-${var.project_id}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(local.common_tags, {
    Name = "shopping-app-bucket"
  })
}

resource "aws_s3_bucket_public_access_block" "shopping_app_bucket" {
  bucket = aws_s3_bucket.shopping_app_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

variable "project_id" {
  description = "Project identifier for unique resource naming"
  type        = string
  default     = "970a9258-88be-4c11-a6fc-bb818ef80c30"
}

locals {
  common_tags = {
    ManagedBy   = "ace"
    Environment = var.environment
    Project     = var.project_id
  }
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}
```

This configuration will create a secure S3 bucket with server-side encryption and public access blocks.