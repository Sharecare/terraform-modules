###################### nfs
resource "helm_release" "nfs" {
  name             = "nfs-ganesha-server"
  chart            = "./helm"
  namespace        = var.namespace
  create_namespace = true

}
