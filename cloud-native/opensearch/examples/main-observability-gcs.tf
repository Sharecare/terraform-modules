# to expose the opensearch-dashboards add an annotation to the
# opensearch_dashboard_overrides at service.annotations
# or even better create it with ambassador CRDS along with this module
# EXAMPLE:
#   example SET if you want to expose opensearch-dashboards
# getambassador.io/config: |
#   ---
#   apiVersion: ambassador/v1
#   kind:  Mapping
#   name: opensearch-dashboards
#   prefix: /
#   host: ${OPENSEARCH_URL}
#   host_regex: false
#   service: opensearch-dashboards.opensearch:5601
#   add_response_headers:
#     Content-Security-Policy: "frame-ancestors 'none'"
#     Strict-Transport-Security: max-age=31536000;
#     X-Frame-Options: deny
#     X-XSS-Protection: 1; mode=block
#     Referrer-Policy: strict-origin-when-cross-origin
#     Feature-Policy: "geolocation 'self'; camera 'self'"
#     X-Content-Type-Options: nosniff

module "opensearch" {
  providers = {
    kubernetes = kubernetes.gke
  }
  dashboards_enabled    = true
  observability_enabled = true
  create_snapshots      = true
  snapshot_bucket       = "toniq-dev-dev-snapshots"
  snapshot_type         = "gcs"
  opensearch_overrides = {
    "keystore[0].secretName"   = "google-application-credentials"
    "persistence.storageClass" = "standard"
  }
  opensearch_dashboard_overrides = {}
  metricbeat_overrides           = {}
  fluentd_overrides              = {}
  source                         = "github.com/doc-ai/terraform-modules//cloud-native//opensearch?ref=vx.x.x"
  depends_on                     = [kubernetes_secret.google-application-credentials]
}


#################### GCP ONLY #####################################
# AWS: will use the role attached to the instance make sure that
# role has a policy to access the snapshot bucket.
#
# GCP: Make sure the service_account_id has a role that can read
# to and write to the gcs bucket.
resource "google_service_account_key" "key" {
  service_account_id = "tf-gke-example-service-account@project-id.iam.gserviceaccount.com"
}

resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "opensearch"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "opensearch"
  }
}

# need to create namespace before opensearch deplpyment to set these
# add storage admin role
resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name      = "google-application-credentials"
    namespace = "opensearch"
  }
  data = {
    "gcs.client.default.credentials_file" = base64decode(google_service_account_key.key.private_key)
  }
  depends_on = [kubernetes_namespace.example]
}