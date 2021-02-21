data "google_compute_image" "image" {
  family  = "wids"
  project = "cloudcover-sandbox"
}

data "google_compute_image" "image_family" {
  family  = "wids"
  project = "cloudcover-sandbox"
}

data "google_compute_image" "image_id" {
  name    = var.image_id == "" ? data.google_compute_image.image_family.image_id : var.image_id
  project = "cloudcover-sandbox"
}
