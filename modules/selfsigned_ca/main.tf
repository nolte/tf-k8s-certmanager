
resource "kubectl_manifest" "certmanager_issuer_selfsigned_ca" {
  depends_on = [var.depends_list]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${var.issuer_name}
spec:
  selfSigned: {}
  YAML
}
