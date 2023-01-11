resource "kubernetes_manifest" "crds" {
  for_each = fileset("${path.module}/crds-3.4.0", "*getambassador.io.yaml")
  manifest = yamldecode(file("${path.module}/crds-3.4.0/${each.value}"))
  depends_on = [ kubernetes_namespace.ingress ]
}

resource "kubernetes_manifest" "yamls" {
  for_each = fileset(path.module, "templates/*yaml")
  manifest = yamldecode(file("${path.module}/${each.value}"))
  depends_on = [ kubernetes_manifest.crds ]
}

resource "kubernetes_manifest" "host" {
  for_each = { for k, v in var.tls_contexts: replace(k, ".", "-") => { provider = v.provider, domain = k} }
  manifest = yamldecode(templatefile("${path.module}/templates/host.tftpl",
    {
      name       = "host-${each.key}"
      hostname   = each.value.domain
      tls_name   = "tls-${each.key}"
      tls_secret = "ambassador-certs-${each.value.provider}-${each.key}"      
    }))
  depends_on = [ kubernetes_manifest.crds ]  
}

resource "kubernetes_manifest" "wildcard" {
  for_each = { for k, v in var.tls_contexts: replace(k, ".", "-") => { provider = v.provider, domain = k} }
  manifest = yamldecode(templatefile("${path.module}/templates/host.tftpl",
    {
      name       = "wildcard-${each.key}"
      hostname   = "*.${each.value.domain}"
      tls_name   = "tls-${each.key}"
      tls_secret = "ambassador-certs-${each.value.provider}-${each.key}"      
    }))
  depends_on = [ kubernetes_manifest.crds ]  
}

resource "kubernetes_manifest" "tlscontext" {
  for_each = { for k, v in var.tls_contexts: replace(k, ".", "-") => { provider = v.provider, domain = k} }
  manifest = yamldecode(templatefile("${path.module}/templates/tlscontext.tftpl",
    {
      tls_secret = "ambassador-certs-${each.value.provider}-${each.key}"
      hostname   = each.value.domain
      name       = "tls-${each.key}"
    }))
  depends_on = [ kubernetes_manifest.crds ]  
}
