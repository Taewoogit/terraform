resource "google_compute_network" "gogle_vpc" {
  project                 = "midyear-spot-368821"
  name                    = "gogle-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "gogle_subnet" {
  name          = "gogle-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "asia-northeast3"
  network       = google_compute_network.gogle_vpc.id
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.gogle_subnet.region
  network = google_compute_network.gogle_vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


output "gogle_vpc" {
  value = google_compute_network.gogle_vpc
}

output "gogle_subnet" {
  value = google_compute_subnetwork.gogle_subnet
}