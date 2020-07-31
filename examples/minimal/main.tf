resource "kubernetes_namespace" "operators" {
  metadata {
    name = "operators"
  }
}

module "certmanager" {
  source            = "../../install"
  release_namespace = kubernetes_namespace.operators.metadata[0].name
}
