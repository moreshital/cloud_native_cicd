resource "google_compute_global_address" "wids" {
  name    = "wids-staging"
  project = var.project_id
  #network_tier = PREMIUM

}

resource "google_compute_global_forwarding_rule" "wids" {
  name       = "wids-staging-port-80"
  project    = var.project_id
  ip_address = google_compute_global_address.wids.address
  port_range = "80"
  target     = google_compute_target_http_proxy.wids.self_link
}

resource "google_compute_target_http_proxy" "wids" {
  name    = "wids-staging"
  project = var.project_id
  url_map = google_compute_url_map.wids.self_link
}

resource "google_compute_url_map" "wids" {
  name            = "wids-staging"
  project         = var.project_id
  default_service = google_compute_backend_service.wids.self_link
}


resource "google_compute_backend_service" "wids" {
  name             = "wids-staging-backend"
  protocol         = "HTTP"
  project          = var.project_id
  port_name        = "wids-staging"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
    group = module.region_instance_group_manager.region_instance_group_manager_instance_group
  }

  health_checks = [google_compute_http_health_check.wids.id]

}

resource "google_compute_http_health_check" "wids" {
  name               = "wids-staging-${var.region}"
  project            = var.project_id
  request_path       = "/"
  timeout_sec        = 5
  check_interval_sec = 5
  port               = 80

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_firewall" "wids" {
  ## firewall rules enabling the load balancer health checks
  name        = "wids-staging-firewall"
  network     = "default"
  project     = var.project_id
  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cloud-native-cicd"]
}
