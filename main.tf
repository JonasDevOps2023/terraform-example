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
