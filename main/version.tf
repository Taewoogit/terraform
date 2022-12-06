provider "google" {
  project = "midyear-spot-368821"
  region  = "asia-northeast3"
  version = "~> 4.0"
}

terraform {
  backend "gcs" {
    bucket = "tw-bucket-tfstate"
    prefix = "terraform/state"
  }
}
