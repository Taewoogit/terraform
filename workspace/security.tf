resource "google_compute_firewall" "ssh" {
  project     = "midyear-spot-368821"
  name        = "tf-vpc-allow-ssh"
  network     = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["bastion"]
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "web" {
  project     = "midyear-spot-368821"
  name        = "tf-vpc-allow-web"
  network     = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  target_tags   = ["web-server"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "mig" {
  project     = "midyear-spot-368821"
  name        = "tf-vpc-allow-web-mig"
  network     = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["web-mig"]
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}