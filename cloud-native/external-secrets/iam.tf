module "external_secrets_workload_identity" {
  count   = var.provider == "gcp" ? 1 : 0
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "20.0.0"
  providers = {
    kubernetes = kubernetes
  }

  name       = var.name
  namespace  = kubernetes_namespace.external-secrets.id
  project_id = var.project_id
  roles = [
    "roles/secretmanager.secretAccessor",
  ]
  depends_on = [
    kubernetes_namespace.external-secrets
  ]
}

resource "kubernetes_namespace" "external-secrets" {
  provider = kubernetes
  metadata {
    annotations = {
      name = var.name
    }

    labels = {
      application = var.name
      name        = var.name
    }

    name = var.name
  }
}
