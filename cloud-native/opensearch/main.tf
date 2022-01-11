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

  set {
    name  = "plugins.installList[0]"
    value = "repository-${var.snapshot_type}"
  }

  dynamic "set" {
    for_each = var.opensearch_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
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

resource "kubernetes_job" "opensearch_init_job" {
  count = var.observability_enabled == true ? 1 : 0
  metadata {
    name      = "opensearch-init-job"
    namespace = "opensearch"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "opensearch-init"
          image   = "alpine:latest"
          command = ["/bin/sh", "-c", data.template_file.cluster-init-script.rendered]
          volume_mount {
            mount_path = "/usr/share/init-files"
            name       = "init-config"
          }
        }
        volume {
          name = "init-config"
          config_map {
            name = "opensearch-dashboards-init"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true

  depends_on = [
    kubernetes_config_map.init-opensearch-dashboards,
    helm_release.dashboards,
    helm_release.opensearch,
    helm_release.metricbeat,
    helm_release.fluentd
  ]
}

data "template_file" "cluster-init-script" {
  template = file("${path.module}/templates/cluster-init.tpl")
}


resource "kubernetes_cron_job" "snapshot" {
  count = var.create_snapshots == true ? 1 : 0
  metadata {
    name      = "opensearch-snaphsot-cronjob"
    namespace = "opensearch"
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "*/5 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 604800
        template {
          metadata {}
          spec {
            container {
              name    = "opensearch-snapshot-creation"
              image   = "alpine:latest"
              command = ["/bin/sh", "-c", data.template_file.snapshot-script.rendered]
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_config_map.init-opensearch-dashboards,
    helm_release.dashboards,
    kubernetes_job.opensearch_init_job,
    helm_release.opensearch
  ]
}

data "template_file" "snapshot-script" {
  template = file("${path.module}/templates/snapshot-creation.tpl")

  vars = {
    TYPE   = var.snapshot_type
    BUCKET = var.snapshot_bucket
  }
}
