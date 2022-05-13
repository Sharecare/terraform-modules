resource "kubernetes_secret" "dns_service_account" {
  for_each = local.clouddns_certs
  provider = kubernetes
  metadata {
    name      = "cert-manager-credentials"
    namespace = var.ambassador_namespace
  }


  data = {
    for k, v in local.clouddns_certs : "${google_service_account.service_account[k].name}.json" => base64encode(google_service_account_key.key[k].private_key)
  }

}

resource "kubernetes_secret" "cloudflare_key" {
  count    = local.has_cloudflare ? 1 : 0
  provider = kubernetes
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = var.ambassador_namespace
  }
  data = {
    "api-token" = var.cloudflare_key
  }
}
