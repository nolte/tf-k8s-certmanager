
data "kubernetes_namespace" "release" {
  metadata {
    name = var.release_namespace
  }
}

resource "helm_release" "release" {
  depends_on = [var.depends_list]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = data.kubernetes_namespace.release.metadata[0].name
  values = [
    "${templatefile("${path.module}/files/values.yml", {})}"
  ]
}
