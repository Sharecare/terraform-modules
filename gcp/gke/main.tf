module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "27.0.0"
  project_id                 = var.project_id
  name                       = "${var.project_id}-cluster"
  region                     = var.region
  zones                      = var.zones
  network                    = var.network_name
  subnetwork                 = var.subnetwork_name
  ip_range_pods              = "${var.project_id}-pods"
  ip_range_services          = "${var.project_id}-services"
  http_load_balancing        = var.http_load_balancing
  grant_registry_access      = var.grant_registry_access
  kubernetes_version         = var.kubernetes_version
  horizontal_pod_autoscaling = true
  network_policy             = true
  default_max_pods_per_node  = var.default_max_pods_per_node
  logging_service            = "logging.googleapis.com/kubernetes"
  monitoring_service         = "monitoring.googleapis.com/kubernetes"
  remove_default_node_pool   = var.remove_default_node_pool
  # enable_private_endpoint    = var.enable_private_endpoint
  # enable_private_nodes       = var.enable_private_nodes
  node_pools                 = var.node_pools
  node_pools_oauth_scopes    = var.node_pools_oauth_scopes
  node_pools_labels          = var.node_pools_labels
  node_pools_metadata        = var.node_pools_metadata
  node_pools_tags            = var.node_pools_tags
}