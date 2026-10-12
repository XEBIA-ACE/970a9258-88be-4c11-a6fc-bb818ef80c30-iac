locals {
  common_tags = merge(
    {
      ManagedBy   = "ace"
      Environment = var.environment
      Project     = var.project_id
    },
    var.tags
  )
}