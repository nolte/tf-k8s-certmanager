
output "issuer_name" {
  value = var.issuer_name
}

output "depend_on" {
  # list all resources in this module here so that other modules are able to depend on this
  value = [
    kubectl_manifest.certmanager_issuer_ca,
    kubectl_manifest.certmanager_issuer_selfsigned_ca,

  ]
}
