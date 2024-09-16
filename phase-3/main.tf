provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "malaa"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "loki" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "monitoring"
  version    = "latest" 

  create_namespace = true

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }

  set {
    name  = "loki.persistence.storageClassName"
    value = "standard"  # Adjust based on your storage class
  }

  # Configure Grafana admin password
  set_sensitive {
    name  = "grafana.adminPassword"
    value = "Admin@123"
  }
}

resource "helm_release" "vector" {
  name       = "vector"
  repository = "https://helm.vector.dev"
  chart      = "vector"
  namespace  = "monitoring"
  version    = "0.24.0"  # Use the latest stable version

  create_namespace = false  # Namespace already created by Loki stack

  set {
    name  = "daemonset.enabled"
    value = "true"
  }

  set {
    name  = "aggregator.enabled"
    value = "false"
  }

  set {
    name  = "daemonset.vectorConfig"
    value = file("vector-config.yaml")
  }
}