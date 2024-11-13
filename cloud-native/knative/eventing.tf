# https://github.com/knative/eventing/releases/download/knative-v1.15.3/eventing-crds.yaml
data "kubectl_file_documents" "eventing-crds" {
    content = file("${path.module}/templates/eventing/eventing-crds.yaml")
}

# https://github.com/knative/eventing/releases/download/knative-v1.15.3/eventing-core.yaml
data "kubectl_file_documents" "eventing-core" {
    # NOTE eventing-core.yaml contains the following changes from the original file provided by knative:
    # changed line 1294 from:
    #    minAvailable: 80%
    # to
    #    minAvailable: EVENTING_WEBHOOK_MIN_AVAILABLE
    content = file("${path.module}/templates/eventing/eventing-core.yaml")
}

# https://github.com/knative/eventing/releases/download/v1.15.3/in-memory-channel.yaml
data "kubectl_file_documents" "in-memory-channel" {
    content = file("${path.module}/templates/eventing/in-memory-channel.yaml")
}

# https://github.com/knative/eventing/releases/download/knative-v1.15.3/mt-channel-broker.yaml
data "kubectl_file_documents" "mt-channel-broker" {
    content = file("${path.module}/templates/eventing/mt-channel-broker.yaml")
}

resource "kubectl_manifest" "eventing-crds" {
    for_each  = data.kubectl_file_documents.eventing-crds.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "eventing-core" {
    for_each  = data.kubectl_file_documents.eventing-core.manifests
    yaml_body = replace(each.value, "EVENTING_WEBHOOK_MIN_AVAILABLE", var.eventing_webhook_min_available)

    depends_on = [
      kubectl_manifest.eventing-crds
    ]
}

resource "kubectl_manifest" "in-memory-channel" {
    for_each  = data.kubectl_file_documents.in-memory-channel.manifests
    yaml_body = each.value

    depends_on = [
      kubectl_manifest.eventing-crds,
      kubectl_manifest.eventing-core
    ]
}

resource "kubectl_manifest" "mt-channel-broker" {
    for_each  = data.kubectl_file_documents.mt-channel-broker.manifests
    yaml_body = each.value

    depends_on = [
      kubectl_manifest.eventing-crds,
      kubectl_manifest.eventing-core,
      kubectl_manifest.in-memory-channel
    ]
}