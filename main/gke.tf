resource "google_container_cluster" "primary" {
  provider                 = google-beta
  name                     = "gogle-cluster"
  location                 = "asia-northeast3"
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.gogle_vpc.id
  subnetwork = google_compute_subnetwork.gogle_subnet.id

  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = ["cloud-platform"]
  }

    ip_allocation_policy {
  }

#   cluster_autoscaling {
#     enabled = true
#     resource_limits {
#       resource_type = "cpu"
#       maximum       = "1000"
#     }
#     resource_limits {
#       resource_type = "memory"
#       maximum       = "1000"
#     }
#   }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }
}

output "gogle_cluster" {
  value = google_container_cluster.primary
  sensitive = true
}