module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.private : s.id]

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  create_cluster_security_group = true
  create_node_security_group    = true

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks.arn
  }

  eks_managed_node_groups = {
    default = {
      desired_size = var.eks_managed_node_desired_size
      min_size     = var.eks_managed_node_min_size
      max_size     = var.eks_managed_node_max_size

      instance_types = var.eks_managed_node_instance_types

      subnet_ids = [for s in aws_subnet.private : s.id]

      labels = {
        role = "managed-node"
      }

      tags = merge(local.common_tags, {
        Name = "${var.environment}-eks-managed-ng"
      })

      capacity_type = "ON_DEMAND"

      block_device_mappings = {
        root = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            encrypted   = true
          }
        }
      }
    }
  }

  fargate_profiles = {
    default = {
      name = "default-fargate-profile"
      selectors = [
        for ns in var.fargate_namespaces : {
          namespace = ns
        }
      ]

      subnet_ids = [for s in aws_subnet.private : s.id]

      tags = merge(local.common_tags, {
        Name = "${var.environment}-eks-fargate-profile"
      })
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = merge(local.common_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}