resource "helm_release" "datadog" {
  name            = "datadog"
  repository      = "https://helm.datadoghq.com"
  chart           = "datadog"
  version         = var.dd_version
  namespace       = "default"
  lint            = true
  force_update    = true
  recreate_pods   = true
  cleanup_on_fail = true


  values = [
    templatefile("./${path.module}/templates/values.yaml",
      {
        DATADOG_API_KEY = var.datadog_api_key
    })
  ]
  dynamic "set" {
    for_each = var.value_overrides
    iterator = override
    content {
      name  = override.key
      value = override.value
    }
  }
}
