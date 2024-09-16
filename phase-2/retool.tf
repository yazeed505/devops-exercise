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

resource "kubernetes_deployment" "demo_api" {
  metadata {
    name = "demo-api"
    labels = {
      app = "demo-api"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "demo-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-api"
        }
      }

      spec {
        container {
          name  = "demo-api"
          image = "hashicorp/http-echo:0.2.3"
          args  = ["-text=Hello World"]

          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "demo_api_service" {
  metadata {
    name = "demo-api-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.demo_api.metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 5678
    }

    type = "ClusterIP"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "default"

  set {
    name  = "controller.service.internal.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.loadBalancerSourceRanges[0]"
    value = aws_vpc.main.cidr_block
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
  }
}

resource "kubernetes_ingress" "demo_api_ingress" {
  metadata {
    name = "demo-api-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/demo"
          backend {
            service_name = kubernetes_service.demo_api_service.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}