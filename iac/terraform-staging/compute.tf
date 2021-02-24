
module "compute_autoscaler" {
  source = "../terraform-modules/region_autoscaler"

  region_autoscaler_name = "widsapp-staging-autoscaler"
  region                 = "asia-south1"


  region_autoscaler_target = module.region_instance_group_manager.region_instance_group_manager_self_link

  project_id  = var.project_id
  description = "prd testing autoscaler"

  autoscaler_max_replicas    = 1
  autoscaler_min_replicas    = 1
  autoscaler_cooldown_period = 60

  metric = []


  cpu_utilization = [
    {
      cpu_utilization_target = "0.7"
    }
  ]
  load_balancing_utilization = []



  timeouts = [
    {
      create = "60m"
      update = "60m"
      delete = "2h"
    },
  ]
}
