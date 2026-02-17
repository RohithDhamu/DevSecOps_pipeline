variable "project_id" {
  type = string
}

variable "location" {
  description = "Region or Zone for GKE cluster"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "node_count" {
  type = number
}

variable "machine_type" {
  type = string
}

variable "gke_node_sa_email" {
  description = "Existing Service Account email for GKE nodes"
  type        = string
}


variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary range name for Pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary range name for Services"
  type        = string
}
