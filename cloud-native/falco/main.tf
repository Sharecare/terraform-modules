###################### FALCO
resource "helm_release" "falco" {

  depends_on = []
  name       = "falco"
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  # version          = "0.2.7"
  namespace        = "falco"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  values = [
    data.template_file.falco_template.rendered,
    data.template_file.falco_custom.rendered
  ]
}

data "template_file" "falco_template" {
  template = file("${path.module}/templates/falco.values.yaml")
}

data "template_file" "falco_custom" {
  template = file("${path.module}/templates/custom.local.yaml")
}

###################### FALCO-SIDEKICK
resource "helm_release" "falco_sidekick" {

  depends_on       = []
  name             = "falcosidekick"
  repository       = "https://falcosecurity.github.io/charts"
  chart            = "falcosidekick"
  version          = "0.2.7"
  namespace        = "falco"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true

  set {
    name  = "config.debug"
    value = "true"
  }
  set {
    name  = "config.kubeless.namespace"
    value = "kubeless"
  }
  set {
    name  = "config.kubeless.function"
    value = "delete-pod"
  }
  set {
    name  = "config.slack.webhookurl"
    value = var.webhookurl
  }
}

###################### KUBELESS DELETE-POD
resource "helm_release" "kubeless" {
  name             = "kubeless-delete-pod"
  chart            = "${path.module}/helm/kubeless"
  namespace        = "kubeless"
  create_namespace = true
  wait             = true
  recreate_pods    = true
  lint             = true
  depends_on       = [kubernetes_namespace.kubeless]
}

resource "kubernetes_namespace" "kubeless" {
  metadata {
    annotations = {
      name = "kubeless"
    }

    labels = {
      application = "kubeless"
    }

    name = "kubeless"
  }
}
