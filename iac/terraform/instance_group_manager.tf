module "region_instance_group_manager" {
  source = "../terraform-modules/instance_group_manager"

  project_id          = var.project_id
  autoscaling_enabled = true

  region                    = "asia-south1"
  base_instance_name        = "widsapp"
  target_size               = 1
  target_pools              = []
  description               = "wids instance group manager"
  distribution_policy_zones = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]
  wait_for_instances        = true
  named_ports = [
    {
      name = "http"
      port = 80
    }
  ]

  auto_healing_policies = []

  update_policy = [
    {
      max_surge_fixed              = 3
      max_surge_percent            = null
      max_unavailable_fixed        = 0
      max_unavailable_percent      = null
      min_ready_sec                = null
      minimal_action               = "REPLACE"
      type                         = "PROACTIVE"
      instance_redistribution_type = null
    },
  ]

  stateful_disk = []

  instance_template_id = module.compute_instance_template.instance_template_self_link


  timeouts = [
    {
      create = "60m"
      update = "60m"
      delete = "2h"
    },
  ]
}
