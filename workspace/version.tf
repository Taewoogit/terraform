provider "google" {
  region  = "asia-northeast3" #Asia Pacific (Seoul Region)
  version = "~> 4.0"
}

data "terraform_remote_state" "workspace" {
  backend = "gcs"
  config = {
    bucket = "tw-bucket-tfstate"
    prefix = "terraform/state"
  }
}