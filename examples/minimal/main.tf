resource "kubernetes_namespace" "operators" {
  metadata {
    name = "operators"
  }
}

module "prometheus_crds" {
  source                     = "git::https://github.com/nolte/tf-k8s-monitoring.git//modules/crds"
  enable_crd_servicemonitors = true
  enable_crd_prometheusrules = false
  enable_crd_alertmanagers   = false
  enable_crd_podmonitors     = false
  enable_crd_prometheuses    = false
  enable_crd_thanosrulers    = false
}

module "certmanager" {
  depends_list      = [module.prometheus_crds.depend_on]
  source            = "../../modules/install"
  release_namespace = kubernetes_namespace.operators.metadata[0].name
}

# give Certsmanger Time to Work
resource "time_sleep" "wait_seconds" {
  depends_on = [module.certmanager.depend_on]

  create_duration = "15s"
}

module "selfsigned_ca" {
  depends_list = [
    time_sleep.wait_seconds,
    module.certmanager.depend_on
  ]
  source = "../../modules/selfsigned_ca"
}
#
