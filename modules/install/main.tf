
data "kubernetes_namespace" "release" {
  metadata {
    name = var.release_namespace
  }
}

resource "kubectl_manifest" "certmanager_crds" {
  depends_on = [var.depends_list]
  yaml_body  = file("${path.module}/files/00-crds.yaml")
}


resource "helm_release" "release" {
  depends_on = [kubectl_manifest.certmanager_crds]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = data.kubernetes_namespace.release.metadata[0].name
  values = [
    "${templatefile("${path.module}/files/values.yml", {})}"
  ]
}
