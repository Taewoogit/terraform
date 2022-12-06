resource "google_compute_global_address" "db_address" {
  name          = "db"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "10.90.0.0"
  prefix_length = 24
  network       = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
}

resource "google_service_networking_connection" "gogle_vpc_connection" {
  network                 = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_address.id]
  depends_on = [ 
    google_compute_global_address.db_address
  ]
}

resource "google_sql_database" "tf-db" {
  name     = "database"
  instance = google_sql_database_instance.tw-mysql.id
}

resource "google_sql_database_instance" "tw-mysql" {
  name             = "tae-mysql"
  database_version = "MYSQL_8_0"
  region           = "asia-northeast3"
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.terraform_remote_state.workspace.outputs.gogle_vpc.id
    }

    availability_type = "REGIONAL"
    backup_configuration {
      binary_log_enabled = true
      enabled=true
    }

    location_preference {
      zone = "asia-northeast3-a"
      secondary_zone = "asia-northeast3-c"
    }
  }

  depends_on = [ 
    google_service_networking_connection.gogle_vpc_connection
  ]
}

resource "google_sql_user" "users" {
  name     = "root"
  instance = google_sql_database_instance.tw-mysql.id
  password = "passwd"
}