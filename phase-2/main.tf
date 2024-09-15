provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "malaa"
}

resource "kubernetes_namespace" "retool" {
  metadata {
    name = "retool"
  }
}