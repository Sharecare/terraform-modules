###################### FALCO
resource "helm_release" "falco" {

  depends_on       = []
  name             = "falco"
  repository       = "https://falcosecurity.github.io/charts"
  chart            = "falco"
  version          = "4.11.1"
  namespace        = "falco"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  cleanup_on_fail  = true

  values = [
    data.template_file.falco_template.rendered,
    data.template_file.falco_custom.rendered
  ]

  set {
    name  = "falcosidekick.enabled"
    value = true
  }

  set {
    name  = "falcosidekick.slack.webhookurl"
    value = var.webhookurl
  }

  # TODO: update once knative stuff is in place
  set {
    name  = "falcosidekick.config.cloudevents.address"
    value = ""
  }
}

data "template_file" "falco_template" {
  template = file("${path.module}/templates/falco.values.yaml")
}

data "template_file" "falco_custom" {
  template = file("${path.module}/templates/custom.local.yaml")
}
