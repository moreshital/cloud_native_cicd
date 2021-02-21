/******************************************
	Region Autoscaler configuration
 *****************************************/

locals {
  description = coalesce(var.description, "Region Autoscaler for ${var.region_autoscaler_name}")
}

resource "google_compute_region_autoscaler" "default_region_autoscaler" {
  provider = google-beta

  name        = var.region_autoscaler_name
  target      = var.region_autoscaler_target
  region      = var.region
  project     = var.project_id
  description = local.description

  autoscaling_policy {
    max_replicas    = var.autoscaler_max_replicas
    min_replicas    = var.autoscaler_min_replicas
    cooldown_period = var.autoscaler_cooldown_period

    dynamic "metric" {
      for_each = var.metric
      content {
        name                       = lookup(metric.value, "metric_name", null)
        filter                     = lookup(metric.value, "metric_filter", null)
        target                     = lookup(metric.value, "metric_target", null)
        type                       = lookup(metric.value, "metric_type", null)
        single_instance_assignment = lookup(metric.value, "metric_single_instance_assignment", null)
      }
    }

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization
      content {
        target = lookup(cpu_utilization.value, "cpu_utilization_target", null)
      }
    }

    dynamic "load_balancing_utilization" {
      for_each = var.load_balancing_utilization
      content {
        target = lookup(load_balancing_utilization.value, "load_balancing_utilization_target", null)
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = lookup(timeouts.value, "create", "60m")
      update = lookup(timeouts.value, "update", "60m")
      delete = lookup(timeouts.value, "delete", "2h")
    }
  }
}
