provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "malaa"
  }
}

resource "helm_release" "retool" {
  name       = "retool"
  repository = "https://charts.retool.com"
  chart      = "retool"
  namespace  = kubernetes_namespace.retool.metadata[0].name

  values = [
    "${file("values.yaml")}"
  ]
}