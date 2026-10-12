resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.38.0"

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = var.cluster_name
      }
      awsRegion = var.aws_region
      cloudProvider = "aws"
      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
          }
        }
      }
      extraArgs = {
        skip-nodes-with-local-storage = "false"
        skip-nodes-with-system-pods   = "false"
        expander                      = "least-waste"
      }
    })
  ]

  depends_on = [
    module.eks,
    aws_iam_role.cluster_autoscaler
  ]
}