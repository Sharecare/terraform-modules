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
}

/*
  NOTE: Using `kubernetes_manifest` resource due to a bug in the terraform provider. Details can be found here:
  https://github.com/hashicorp/terraform-provider-kubernetes/issues/1724#issuecomment-1139450178
*/
resource "kubernetes_manifest" "state_metrics_local_sa" {
  provider = kubernetes.local

  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      namespace = kubernetes_namespace.mon_local.metadata[0].name
      name      = "state-metrics"

      labels = {
        app = "state-metrics"
      }
    }

    automountServiceAccountToken = false
  }
}