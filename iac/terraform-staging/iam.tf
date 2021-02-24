resource "google_service_account" "serviceaccount" {
  account_id   = "compute-wids-staging"
  display_name = "wids GCE Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.serviceaccount.email}"
}

resource "google_project_iam_member" "secretmanager_accessor" {
  project = "cloudcover-sandbox"
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.serviceaccount.email}"
}
