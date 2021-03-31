resource "helm_release" "cert_manager" {

  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.1.0"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = var.installCRDs
  }

  set {
    name  = "extraArgs"
    value = "{--dns01-recursive-nameservers=8.8.8.8:53,8.8.4.4:53,--dns01-recursive-nameservers-only=true}"
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    annotations = {
      name = "ingress"
    }

    labels = {
      application = "ambassador"
    }

    name = "ingress"
  }
}

resource "kubernetes_secret" "secret_keys" {
  count      = var.provder != "clouddns" ? 1 : 0
  depends_on = [kubernetes_namespace.ingress]
  metadata {
    name      = "helm-secrets-keys"
    namespace = "ingress"
  }

  data = {
    "cloudflare-api-key" = var.cloudflare_key
  }
}



resource "null_resource" "sa_account" {

  count = var.provder == "clouddns" ? 1 : 0
  depends_on = [
    helm_release.cert_manager,
    kubernetes_namespace.ingress,
  ]
  provisioner "local-exec" {
    command = "./${path.module}/scripts/dns-admin-sa.sh $DNS_PROJECT_ID"

    environment = {
      DNS_PROJECT_ID = var.dns_project_id
      KUBECONFIG     = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
    }
  }
}

######################
####### issuer #######
data "template_file" "issuer_template" {
  count      = var.provder == "clouddns" ? 1 : 0
  depends_on = [null_resource.sa_account]
  template   = file("${path.module}/templates/${var.provder}/issuer.tpl")
  vars = {
    DNS_PROJECT_ID = var.dns_project_id
  }
}


resource "local_file" "issuer_yaml" {
  count    = var.provder == "clouddns" ? 1 : 0
  content  = data.template_file.issuer_template[0].rendered
  filename = "${path.module}/templates/${var.provder}/issuer.yaml"
}



resource "null_resource" "issuer_yaml_apply" {
  count      = var.provder == "clouddns" ? 1 : 0
  depends_on = [local_file.issuer_yaml]
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/${var.provder}/issuer.yaml"

    environment = {
      KUBECONFIG = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
    }
  }
}


######################
####### cloud flare issuer #######


resource "null_resource" "cf_issuer_yaml_apply" {
  depends_on = [
    kubernetes_secret.secret_keys,
    helm_release.cert_manager,
  ]
  count = var.provder != "clouddns" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/${var.provder}/issuer.yaml"

    environment = {
      KUBECONFIG = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
    }
  }
}



######################
####### certificate #######
data "template_file" "certificate_template" {
  depends_on = [null_resource.sa_account, null_resource.issuer_yaml_apply, null_resource.cf_issuer_yaml_apply]
  template   = file("${path.module}/templates/certificate.tpl")
  vars = {
    PROVIDER    = var.provder
    COMMOM_NAME = var.common_name
  }
}


resource "local_file" "certificate_yaml" {
  content  = data.template_file.certificate_template.rendered
  filename = "${path.root}/.terraform/${terraform.workspace}/certificate.yaml"
}



resource "null_resource" "certificate_yaml_apply" {
  depends_on = [local_file.certificate_yaml]
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.root}/.terraform/${terraform.workspace}/certificate.yaml"

    environment = {
      KUBECONFIG = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
    }
  }
}


######################
data "template_file" "ambassador_template" {
  depends_on = [null_resource.certificate_yaml_apply]
  template   = file("${path.module}/templates/ambassador/values.tpl")
  vars = {
    PROVIDER    = var.provder
    COMMON_NAME = var.common_name
  }
}

resource "helm_release" "ambassador" {

  depends_on = [
    helm_release.cert_manager,
    null_resource.certificate_yaml_apply,
    kubernetes_namespace.ingress,
  ]

  name             = "ambassador"
  repository       = "https://getambassador.io"
  chart            = "ambassador"
  version          = "6.5.8"
  namespace        = "ingress"
  create_namespace = true
  wait             = true
  recreate_pods    = true

  values = [
    data.template_file.ambassador_template.rendered
  ]
  set {
    name  = "authService.create"
    value = "false"
  }
  set {
    name  = "rateLimit.create"
    value = "false"
  }
}

# resource "null_resource" "aes_apply" {
#   depends_on = [helm_release.ambassador]
#   provisioner "local-exec" {
#     command = "kubectl apply -f https://www.getambassador.io/yaml/aes-crds.yaml"

#     environment = {
#       KUBECONFIG = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
#     }
#   }
# }

resource "null_resource" "ambassador_ip" {
  depends_on = [helm_release.ambassador]
  provisioner "local-exec" {
    command = "sleep 60 && kubectl get svc --namespace  ingress ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}' > ${path.root}/.terraform/${terraform.workspace}/ambassador_ip.txt"
    environment = {
      KUBECONFIG = "${path.root}/.terraform/${terraform.workspace}/kubeconfig"
    }
  }

}

data "local_file" "ambassador_ip_text" {
  filename   = "${path.root}/.terraform/${terraform.workspace}/ambassador_ip.txt"
  depends_on = [null_resource.ambassador_ip]
}

### Cloudflare ###

data "cloudflare_zones" "doc_ai" {

  count = var.provder != "clouddns" ? 1 : 0
  filter {
    name = "doc.ai"
  }
}

resource "cloudflare_record" "toniq_api_backend" {
  count   = var.provder != "clouddns" ? 1 : 0
  zone_id = lookup(data.cloudflare_zones.doc_ai[0].zones[0], "id")
  name    = "${var.product}-api"
  value   = data.local_file.ambassador_ip_text.content
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "toniq_console_backend" {
  count   = var.provder != "clouddns" ? 1 : 0
  zone_id = lookup(data.cloudflare_zones.doc_ai[0].zones[0], "id")
  name    = "${var.product}-console"
  value   = data.local_file.ambassador_ip_text.content
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "toniq_session_backend" {
  count   = var.provder != "clouddns" ? 1 : 0
  zone_id = lookup(data.cloudflare_zones.doc_ai[0].zones[0], "id")
  name    = "${var.product}-session"
  value   = data.local_file.ambassador_ip_text.content
  type    = "A"
  proxied = false
}


resource "cloudflare_record" "toniq_minio_backend" {
  count   = var.provder != "clouddns" ? 1 : 0
  zone_id = lookup(data.cloudflare_zones.doc_ai[0].zones[0], "id")
  name    = "${var.product}-minio"
  value   = data.local_file.ambassador_ip_text.content
  type    = "A"
  proxied = false
}

#### Clouddns ###

data "google_dns_managed_zone" "dns_entry" {
  count   = var.provder == "clouddns" ? 1 : 0
  name    = var.zone_name
  project = var.dns_project_id
}

resource "google_dns_record_set" "toniq_api_backend" {
  count        = var.provder == "clouddns" ? 1 : 0
  depends_on   = [helm_release.ambassador]
  name         = "${var.product}-api.${data.google_dns_managed_zone.dns_entry[0].dns_name}"
  managed_zone = data.google_dns_managed_zone.dns_entry[0].name
  type         = "A"
  ttl          = 300

  rrdatas = [data.local_file.ambassador_ip_text.content]
  project = var.dns_project_id
}

resource "google_dns_record_set" "session_backend" {
  count        = var.provder == "clouddns" ? 1 : 0
  depends_on   = [helm_release.ambassador]
  name         = "${var.product}-session.${data.google_dns_managed_zone.dns_entry[0].dns_name}"
  managed_zone = data.google_dns_managed_zone.dns_entry[0].name
  type         = "A"
  ttl          = 300

  rrdatas = [data.local_file.ambassador_ip_text.content]
  project = var.dns_project_id
}

resource "google_dns_record_set" "console_backend" {
  count        = var.provder == "clouddns" ? 1 : 0
  depends_on   = [helm_release.ambassador]
  name         = "${var.product}-console.${data.google_dns_managed_zone.dns_entry[0].dns_name}"
  managed_zone = data.google_dns_managed_zone.dns_entry[0].name
  type         = "A"
  ttl          = 300

  rrdatas = [data.local_file.ambassador_ip_text.content]
  project = var.dns_project_id
}

resource "google_dns_record_set" "minio_backend" {
  count        = var.provder == "clouddns" ? 1 : 0
  depends_on   = [helm_release.ambassador]
  name         = "${var.product}-minio.${data.google_dns_managed_zone.dns_entry[0].dns_name}"
  managed_zone = data.google_dns_managed_zone.dns_entry[0].name
  type         = "A"
  ttl          = 300

  rrdatas = [data.local_file.ambassador_ip_text.content]
  project = var.dns_project_id
}


resource "null_resource" "done" {
  depends_on = [
    google_dns_record_set.toniq_api_backend,
    google_dns_record_set.console_backend,
    google_dns_record_set.session_backend,
    google_dns_record_set.minio_backend,
    cloudflare_record.toniq_api_backend,
    cloudflare_record.toniq_console_backend,
    cloudflare_record.toniq_session_backend,
    cloudflare_record.toniq_minio_backend,
    helm_release.cert_manager,
    helm_release.ambassador,
  ]
}
