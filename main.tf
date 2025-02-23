terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.33.0"
    }
  }

  required_version = ">= 1.9.8"
}



provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "rancher-desktop"
}

module "namespace" {
  source = "./modules/namespace"

  namespace_name = var.ns_name
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    namespace = "web"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        namespace = "web"
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}