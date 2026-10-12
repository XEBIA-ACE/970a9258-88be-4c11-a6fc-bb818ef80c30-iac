resource "kubernetes_namespace" "fargate" {
  for_each = toset(var.fargate_namespaces)

  metadata {
    name = each.key
    labels = {
      "aws-usage" = "fargate"
    }
  }
}