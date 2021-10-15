resource "helm_release" "fluentd" {
  name             = "fluentd"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluentd"
  version          = "0.2.11"
  namespace        = "fluentd"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/values.yaml", {})]
}
