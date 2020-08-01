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


resource "tls_private_key" "ingress" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "ingress" {
  key_algorithm   = "ECDSA"
  private_key_pem = tls_private_key.ingress.private_key_pem
  dns_names = [
    "192-168-178-51.sslip.io",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ]

  subject {
    common_name         = "192-168-178-51.sslip.io"
    organization        = "ACME Examples, Inc"
    organizational_unit = "Development"
    street_address      = ["1234 Main Street"]
    locality            = "Beverly Hills"
    province            = "CA"
    country             = "USA"
    postal_code         = "90210"
  }
  # 175200 = 20 years
  validity_period_hours = 175200

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
  is_ca_certificate = true
}

resource "kubernetes_secret" "ingress" {
  metadata {
    name      = "ca-key-pair"
    namespace = kubernetes_namespace.operators.metadata[0].name
  }

  data = {
    "tls.crt" = tls_self_signed_cert.ingress.cert_pem
    "tls.key" = tls_private_key.ingress.private_key_pem
  }

  type = "kubernetes.io/tls"
}



module "selfsigned_ca" {
  depends_list = [
    time_sleep.wait_seconds,
    module.certmanager.depend_on
  ]
  source                       = "../../modules/selfsigned_ca"
  issuer_selfsigned_enabled    = false
  issuer_selfsigned_ca_enabled = true
  issuer_ca_secretName         = kubernetes_secret.ingress.metadata[0].name
}
#
