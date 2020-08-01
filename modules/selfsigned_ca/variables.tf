
variable "issuer_name" {
  default = "cluster-issuer"
}

variable "issuer_selfsigned_enabled" {
  default = true
}
variable "issuer_selfsigned_ca_enabled" {
  default = false
}

variable "issuer_ca_secretName" {
  default = ""
}

variable "depends_list" {
  default = []
}
