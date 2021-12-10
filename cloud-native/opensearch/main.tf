resource "helm_release" "opensearch" {
  name             = "opensearch"
  repository       = "https://opensearch-project.github.io/helm-charts/"
  chart            = "opensearch"
  version          = "1.4.2"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/opensearch.values.yaml", {})]

  dynamic "set" {
    for_each = var.opensearch_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  # depends_on = [kubernetes_storage_class.opensearch]
}

resource "helm_release" "dashboards" {
  count            = var.dashboards_enabled ? 1 : 0
  name             = "opensearch-dashboards"
  repository       = "https://opensearch-project.github.io/helm-charts/"
  chart            = "opensearch-dashboards"
  version          = "1.0.8"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  timeout          = 300
  values           = [templatefile("./${path.module}/templates/dashboards.values.yaml", {})]

  dynamic "set" {
    for_each = var.opensearch_dashboard_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [helm_release.opensearch]
}

resource "helm_release" "metricbeat" {
  count            = var.observability_enabled ? 1 : 0
  name             = "metricbeat-oss"
  repository       = "https://helm.elastic.co"
  chart            = "metricbeat"
  version          = "7.12.1"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  timeout          = 180

  values = [templatefile("./${path.module}/templates/metricbeat.yaml", {})]
  dynamic "set" {
    for_each = var.metricbeat_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [helm_release.dashboards, helm_release.opensearch]
}

# curl --user admin:admin -XPUT 'http://opensearch-cluster-master.opensearch:9200/idx'

# resource "kubernetes_storage_class" "opensearch" {
#   count = var.cloud_provider == "gcp" ? 1 : 0
#   metadata {
#     name = "opensearch-regional"
#   }
#   storage_provisioner = "kubernetes.io/gce-pd"
#   reclaim_policy      = "Delete"
#   volume_binding_mode = "Immediate"
#   parameters = {
#     type             = "pd-ssd"
#     fsType           = "ext4" # default prefered by elasticsearch
#     replication-type = "regional-pd"
#   }
#   allowed_topologies {
#     match_label_expressions {
#       key = "failure-domain.beta.kubernetes.io/zone"
#       values = var.pv_zones
#     }
#   }
#   allow_volume_expansion = true
# }


# resource "kubernetes_storage_class" "opensearch-aws" {
#   count = var.cloud_provider == "aws" ? 1 : 0
#   metadata {
#     name = "opensearch-aws"
#   }
#   storage_provisioner = "kubernetes.io/aws-ebs"
#   reclaim_policy      = "Delete"
#   volume_binding_mode = "WaitForFirstConsumer"
#   parameters = {
#     type   = "gp2"
#     fsType = "ext4" # default prefered by elasticsearch
#   }
#   allowed_topologies {
#     match_label_expressions {
#       key = "failure-domain.beta.kubernetes.io/zone"
#       values = var.pv_zones
#     }
#   }
#   allow_volume_expansion = true
# }


resource "helm_release" "fluentd" {
  count            = var.observability_enabled ? 1 : 0
  name             = "fluentd"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluentd"
  version          = "0.2.11"
  namespace        = "opensearch"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  timeout          = 120
  dynamic "set" {
    for_each = var.fluentd_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
  values = [templatefile("./${path.module}/templates/fluentd.yaml", {})]
}



resource "kubernetes_config_map" "init-opensearch-dashboards" {
  count = var.observability_enabled == true ? 1 : 0
  metadata {
    name      = "opensearch-dashboards-init"
    namespace = "opensearch"
  }

  data = {
    "export.ndjson"                     = file("${path.module}/templates/export.ndjson")
    "deleteold-logs-indices.json"       = file("${path.module}/templates/deleteold-logs-indices.json")
    "deleteold-metricbeat-indices.json" = file("${path.module}/templates/deleteold-metricbeat-indices.json")
    "rollup-metricbeat.json"            = file("${path.module}/templates/rollup-metricbeat.json")
  }
}
