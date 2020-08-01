

output "release_namespace" {
  value = data.kubernetes_namespace.release.metadata[0].name
}

output "depend_on" {
  # list all resources in this module here so that other modules are able to depend on this
  value = [
    kubectl_manifest.certmanager_crds,
    helm_release.release,

  ]
}
