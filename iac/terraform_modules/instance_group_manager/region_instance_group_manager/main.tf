/******************************************
Region Instance Group Manager configuration
*****************************************/

locals {
  distribution_policy_zones_base = {
    default = data.google_compute_zones.available.names
    user    = var.distribution_policy_zones
  }

  distribution_policy_zones = local.distribution_policy_zones_base[length(var.distribution_policy_zones) == 0 ? "default" : "user"]
  description               = coalesce(var.description, "Region Instance Group Manager for ${var.base_instance_name}")
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_region_instance_group_manager" "default" {
  provider = google-beta

  base_instance_name        = var.base_instance_name
  project                   = var.project_id
  name                      = "${var.base_instance_name}-rigm"
  region                    = var.region
  description               = local.description
  distribution_policy_zones = local.distribution_policy_zones
  target_pools              = var.target_pools
  target_size               = var.autoscaling_enabled ? null : var.target_size
  wait_for_instances        = var.wait_for_instances

  version {
    name              = var.base_instance_name
    instance_template = var.instance_template_id
  }

  dynamic "version" {
    for_each = var.canary_instance_template_id == null ? [] : list(var.canary_instance_template_id)
    content {
      name              = "${var.base_instance_name}-canary"
      instance_template = var.canary_instance_template_id
      target_size {
        fixed   = var.fixed
        percent = var.percent
      }
    }
  }

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = lookup(named_port.value, "name", null)
      port = lookup(named_port.value, "port", null)
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_policies
    content {
      health_check      = auto_healing_policies.value.health_check
      initial_delay_sec = lookup(auto_healing_policies.value, "initial_delay_sec", 60)
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy
    content {
      max_surge_fixed              = lookup(update_policy.value, "max_surge_fixed", null)
      max_surge_percent            = lookup(update_policy.value, "max_surge_percent", null)
      max_unavailable_fixed        = lookup(update_policy.value, "max_unavailable_fixed", null)
      max_unavailable_percent      = lookup(update_policy.value, "max_unavailable_percent", null)
      min_ready_sec                = lookup(update_policy.value, "min_ready_sec", null)
      instance_redistribution_type = lookup(update_policy.value, "instance_redistribution_type", null)
      minimal_action               = update_policy.value.minimal_action
      type                         = update_policy.value.type
    }
  }

  dynamic "stateful_disk" {
    for_each = var.stateful_disk
    content {
      device_name = lookup(stateful_disk.value, "device_name", null)
      delete_rule = lookup(stateful_disk.value, "delete_rule", null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [distribution_policy_zones]
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
