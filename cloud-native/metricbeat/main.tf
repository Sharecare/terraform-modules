resource "helm_release" "metricbeat" {
  name             = "metricbeat"
  repository       = "https://helm.elastic.co"
  chart            = "metricbeat"
  version          = "7.15.0"
  namespace        = "elasticsearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/values.yaml", {})]
}