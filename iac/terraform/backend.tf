terraform {
  required_version = "~> 0.12.29"

  backend "gcs" {
    bucket = "wids-terraform-state"
    prefix = "infrastructure/demo/wids"
  }
}

provider "google" {
  version = "~> 3.40"
}

provider "google-beta" {
  version = "~> 3.40"
}
