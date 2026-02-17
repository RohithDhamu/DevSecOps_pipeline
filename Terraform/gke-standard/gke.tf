module "gke_cluster" {
  source = "../modules/gke-standard"

  project_id   = var.project_id
  location     = var.location
  cluster_name = var.cluster_name
  node_count   = var.node_count
  machine_type = var.machine_type

  network              = var.network
  subnetwork           = var.subnetwork
  pods_range_name      = var.pods_range_name
  services_range_name  = var.services_range_name
  gke_node_sa_email    = var.gke_node_sa_email
}
