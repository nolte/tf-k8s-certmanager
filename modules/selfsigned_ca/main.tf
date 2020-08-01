
resource "kubectl_manifest" "certmanager_issuer_selfsigned_ca" {
  depends_on = [var.depends_list]
  count      = var.issuer_selfsigned_enabled ? 1 : 0
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${var.issuer_name}
spec:
  selfSigned: {}
  YAML
}

resource "kubectl_manifest" "certmanager_issuer_ca" {
  depends_on = [var.depends_list]
  count      = var.issuer_selfsigned_ca_enabled ? 1 : 0
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${var.issuer_name}
spec:
  ca:
    secretName: ${var.issuer_ca_secretName}
  YAML
}
