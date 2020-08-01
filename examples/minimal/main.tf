resource "kubernetes_namespace" "operators" {
  metadata {
    name = "operators"
  }
}

data "http" "template" {
  url = "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml"
}

#data "template_file" "init" {
#  template =
#}
#
resource "kubectl_manifest" "test" {
  yaml_body = data.http.template.body
}


module "certmanager" {
  depends_list      = [kubectl_manifest.test]
  source            = "../../modules/install"
  release_namespace = kubernetes_namespace.operators.metadata[0].name
}

# give Certsmanger Time to Work
resource "time_sleep" "wait_30_seconds" {
  depends_on = [module.certmanager.depend_on]

  create_duration = "15s"
}

module "selfsigned_ca" {
  depends_list = [
    time_sleep.wait_30_seconds,
    module.certmanager.depend_on
  ]
  source = "../../modules/selfsigned_ca"
}
#
