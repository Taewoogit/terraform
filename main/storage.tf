resource "google_storage_bucket" "default" {
  name          = "tw-bucket-tfstate"
  force_destroy = false
  location      = "asia"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}