resource "kubernetes_namespace" "frontend" {
  metadata {
    name = var.namespace_name
  }
}
