project_id   = "<project-id>"
location     = "us-central1-a"
cluster_name = "rohith-task"

machine_type        = "e2-medium"
gke_node_sa_email   = "<service-account>"

min_node_count = 1
max_node_count = 3

network              = "rohith-vpc"
subnetwork           = "rohith-subnet-1"
pods_range_name      = "rohith-gpod"
services_range_name  = "rohith-gsvc"
