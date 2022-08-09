module "external_secrets_workload_identity" {
  count   = var.cloud_provider == "gcp" ? 1 : 0
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "22.1.0"
  providers = {
    kubernetes = kubernetes
  }

  name       = var.name
  namespace  = kubernetes_namespace.external-secrets.id
  project_id = var.project_id
  roles      = var.gcp_roles
  depends_on = [
    kubernetes_secret.external_secrets_local_sa_token
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

resource "kubernetes_secret" "external_secrets_local_sa_token" {
  count    = var.create_service_account_secret ? 1 : 0
  provider = kubernetes

  metadata {
    name      = "${var.name}-token"
    namespace = kubernetes_namespace.external-secrets.id
    annotations = {
      "kubernetes.io/service-account.name" = var.cloud_provider == "gcp" ? var.name : "external-secrets-aws"
      "kubernetes.io/service-account.uid" = random_uuid.sa.result
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "random_uuid" "sa" {
  count    = var.create_service_account_secret ? 1 : 0
}
