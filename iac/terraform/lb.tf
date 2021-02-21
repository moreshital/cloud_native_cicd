module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 3.1"
  security_policy   = google_compute_security_policy.policy.self_link
  name              = "widslb-001"
  project           = var.project_id
  firewall_projects = [var.network_project_id]
  firewall_networks = [var.network]
  ssl               = false
  #  ssl_certificates     = [data.google_compute_ssl_certificate.my_cert.self_link]
  use_ssl_certificates = false
  target_tags          = ["ssh", "cloud-native-cicd"]
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = "80"
      port_name                       = "http"
      timeout_sec                     = 60
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null

      health_check = {
        #type                = "TCP"
        check_interval_sec  = 60
        timeout_sec         = 60
        healthy_threshold   = 1
        unhealthy_threshold = 10
        request_path        = null
        port                = "80"
        host                = null
        logging             = null
      }


      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = module.region_instance_group_manager.region_instance_group_manager_instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]
    }
  }
}
