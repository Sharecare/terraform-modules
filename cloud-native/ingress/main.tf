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


resource "null_resource" "done" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.ambassador,
  ]
}
