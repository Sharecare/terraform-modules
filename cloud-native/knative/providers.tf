terraform {
  required_version = ">= 1.9.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    kubectl = {
      source           = "gavinbunney/kubectl"
      version          = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  load_config_file = false
}