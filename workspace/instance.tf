data "google_compute_default_service_account" "default" {
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n1-standard-1"
  zone         = "asia-northeast3-a"
  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp"
    }
  }

  network_interface {
    network    = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
    subnetwork = data.terraform_remote_state.workspace.outputs.gogle_subnet.id
    
    access_config {
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform", "cloud-source-repos"]
  }
  metadata_startup_script = data.template_file.startup_script.rendered
  # depends_on              = [google_container_cluster.regional]

}

data "template_file" "startup_script" {
  template = <<EOF
  echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> /etc/profile
  sudo yum install -y google-cloud-sdk-gke-gcloud-auth-plugin
  sudo yum install -y kubectl
  sudo yum install -y bash-completion
  source <(kubectl completion bash)
  echo "gcloud container clusters get-credentials $${cluster_name} --zone $${cluster_zone} --project $${project} > /dev/null 2>&1" >> /etc/profile
  echo "source <(kubectl completion bash)" >> /etc/bashrc
  sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
  sudo yum install -y yum-utils
  sudo yum-config-manager \
      --add-repo \
       https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  systemctl enable --now docker
  sudo usermod -a -G docker chlxodnr2127
  sudo yum install -y git
  EOF

  vars = {
    cluster_name = "gogle-cluster"
    cluster_zone = "asia-northeast3"
    project = "midyear-spot-368821"
  }
}