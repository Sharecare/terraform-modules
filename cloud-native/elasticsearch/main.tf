resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
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

resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  version          = "7.15.0"
  namespace        = "elasticsearch"
  create_namespace = true
  wait             = true
  recreate_pods    = false
  lint             = true
  wait_for_jobs    = true
  timeout          = 300

  values = [templatefile("./${path.module}/templates/kibana.values.yaml", {})]
}