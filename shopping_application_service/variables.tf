variable "project_id" {
  description = "Project identifier for tagging"
  type        = string
  default     = "970a9258-88be-4c11-a6fc-bb818ef80c30"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24"]
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "dev-eks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "eks_managed_node_instance_types" {
  description = "Instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_managed_node_desired_size" {
  description = "Desired node count for managed node group"
  type        = number
  default     = 2
}

variable "eks_managed_node_min_size" {
  description = "Min node count for managed node group"
  type        = number
  default     = 1
}

variable "eks_managed_node_max_size" {
  description = "Max node count for managed node group"
  type        = number
  default     = 4
}

variable "fargate_namespaces" {
  description = "List of Kubernetes namespaces to schedule on Fargate"
  type        = list(string)
  default     = ["fargate-apps"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}