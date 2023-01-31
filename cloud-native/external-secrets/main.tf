resource "helm_release" "external_secrets" {
  provider         = helm
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = true
  namespace        = kubernetes_namespace.external_secrets.id
  version          = var.helm_version
  lint             = true
  recreate_pods    = true
  wait             = true


  dynamic "set" {
    for_each = merge(var.overrides,
      {
        "serviceAccount.name" = "external-secrets"
      },
      {
        "serviceAccount.create" = "false"
      },
      {
        "installCRDs" = "false"
      }
    )

    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [
    module.external_secrets_sa,
    kubectl_manifest.crds
  ]
}
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
  provider = kubernetes
}

data "kubectl_file_documents" "crds" {
  provider = kubectl
  content  = file("${path.module}/templates/crds.yaml")
}

resource "kubectl_manifest" "crds" {
  provider  = kubectl
  for_each  = data.kubectl_file_documents.crds.manifests
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.external_secrets
  ]
}

################################ GCP specific resources below this line ############################

module "external_secrets_sa" {
  count      = var.cloud_provider == "gcp" ? 1 : 0
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version    = "24.1.0"
  name       = "external-secrets"
  namespace  = kubernetes_namespace.external_secrets.id
  project_id = var.project_id
  roles      = ["roles/iam.serviceAccountTokenCreator", "roles/secretmanager.secretAccessor"]
  providers = {
    kubernetes = kubernetes
  }
}

module "external_secrets_namespace_sa" {
  for_each   = { for k, v in toset(var.namespaces) : k => v if var.cloud_provider == "gcp" }
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version    = "24.1.0"
  name       = "secret-store-${each.value}"
  namespace  = each.value
  project_id = var.project_id
  roles      = ["roles/iam.serviceAccountTokenCreator", "roles/secretmanager.secretAccessor"]
  providers = {
    kubernetes = kubernetes
  }
}

resource "kubectl_manifest" "gcp_secret_store" {
  for_each  = { for k, v in toset(var.namespaces) : k => v if var.cloud_provider == "gcp" }
  provider  = kubectl
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: "${each.value}-secretstore"
  namespace: ${each.value}
spec:
  retrySettings:
    maxRetries: 5
    retryInterval: "10s"
  provider:
    gcpsm:
      projectID: ${var.project_id}
      auth:
        workloadIdentity:
          clusterLocation: ${var.gke_location}
          clusterName: ${var.cluster_name}
          serviceAccountRef:
            name: ${module.external_secrets_namespace_sa[each.value].k8s_service_account_name}
YAML
  depends_on = [
    helm_release.external_secrets
  ]
}

################################ AWS specific resources below this line ############################

resource "kubectl_manifest" "aws_secret_store" {
  for_each  = { for k, v in toset(var.namespaces) : k => v if var.cloud_provider == "aws" }
  provider  = kubectl
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: "${each.value}-secretstore"
  namespace: ${each.value}
spec:
  retrySettings:
    maxRetries: 5
    retryInterval: "10s"
  provider:
    aws:
      service: SecretsManager
      role: arn:aws:iam::123456789012:role/external-secrets
      region: ${var.gke_location}
      auth:
        jwt:
          serviceAccountRef:
            name: k8s serviceaccount name
YAML
}
