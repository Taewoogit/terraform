resource "google_container_node_pool" "service_nodes" {
  provider           = google-beta
  name               = "service-pool"
  cluster            = data.terraform_remote_state.nodepool.outputs.gogle_cluster.id
  initial_node_count = 1

  node_locations = ["asia-northeast3-b", "asia-northeast3-c"]

  node_config {
    machine_type = "e2-medium"
    preemptible  = true

    labels = {
      "node" = "service"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  network_config {
    create_pod_range    = true
    pod_ipv4_cidr_block = "10.32.0.0/16"
    pod_range           = "service-pod-range"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }
}

resource "google_container_node_pool" "cicd_nodes" {
  provider           = google-beta
  name               = "cicd-pool"
  cluster            = data.terraform_remote_state.nodepool.outputs.gogle_cluster.id
  initial_node_count = 1

  node_locations = ["asia-northeast3-a"]

  node_config {
    machine_type = "e2-medium"
    preemptible  = true
    
    labels = {
      "node" = "cicd"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  network_config {
    create_pod_range    = true
    pod_ipv4_cidr_block = "10.42.0.0/16"
    pod_range           = "cicd-pod-range"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}