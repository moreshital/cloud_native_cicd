# Region Instance Group Manager

```
The Google Compute Engine Regional Instance Group Manager API creates and manages pools of homogeneous Compute Engine virtual machine instances from a common instance template.
```

## EXAMPLE Usage

```hcl
module "app_health_check" {
  source = "git::ssh://git@bitbucket.org/ovoeng/terraform-module.git//gcp/compute/health_check?ref=master"
  project_id        = "grovo-dev-core"
  health_check_name = "hc-dj-testing-rigm"
  backend = {
    default = {
      protocol = "HTTP"
      health_check = {
        description         = "testing"
        check_interval_sec  = 5
        timeout_sec         = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port                = "80"
        response            = "I AM HEALTHY"
        proxy_header        = "NONE"
        port_name           = "health-check-port"
        port_specification  = null
      }
    }
  }
}

output "health_check_id" {
  value = module.app_health_check.health_check_id
}

output "region_instance_group_manager_self_link" {
  description = "Self-link of region managed instance group"
  value       = module.instance_group_manager.region_instance_group_manager_self_link
}

module "instance_group_manager" {
  source = "git::ssh://git@bitbucket.org/ovoeng/terraform-module.git//gcp/compute/instance_group_manager/region_instance_group_manager?ref=master"

  project_id                = "grovo-dev-core"
  autoscaling_enabled       = false
  region                    = "asia-southeast2"
  base_instance_name        = "dheeraj-testing-rigm"
  target_size               = 3
  target_pools              = []
  description               = "dheeraj testing region instance group manager"
  distribution_policy_zones = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
  wait_for_instances        = true
  named_ports = [
    {
      name = "http"
      port = 8088
    },
    {
      name = "https"
      port = 8443
    },
  ]

  auto_healing_policies = [
    {
      health_check      = element(module.app_health_check.health_check_id, 0)
      initial_delay_sec = 60
    },
  ]

  update_policy = [
    {
      max_surge_fixed              = null
      max_surge_percent            = null
      max_unavailable_fixed        = 3
      max_unavailable_percent      = null
      min_ready_sec                = null
      minimal_action               = "RESTART"   # REPLACE
      type                         = "PROACTIVE" # OPPORTUNISTIC
      instance_redistribution_type = null
    },
  ]

  stateful_disk = []

  instance_template_id        = "projects/grovo-dev-core/global/instanceTemplates/test-20200703095356141900000001"
  canary_instance_template_id = "projects/grovo-dev-core/global/instanceTemplates/test-20200703095356141900000001"
  percent                     = null
  fixed                       = 0

  timeouts = [
    {
      create = "60m"
      update = "60m"
      delete = "2h"
    },
  ]
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| autoscaling\_enabled | If enable then won't use target_size | bool | `false` | no |
| project\_id | The GCP project ID | string | `n/a` | yes |
| base\_instance\_name | The base instance name to use for instances in this group. The value must be a valid RFC1035 name. Supported characters are lowercase letters, numbers, and hyphens (-). Instances are named by appending a hyphen and a random four-character string to the base instance name | string | `n/a` | yes |
| region | The region where the managed instance group resides | string | `"asia-southeast2"` | yes |
| target\_size | The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set. Defaults to 0. | number | `0` | yes |
| target_pools | The target load balancing pools to assign this group to. The full URL of all target pools to which new instances in the group are added. Updating the target pools attribute does not affect existing instances | list(string) | `[]` | no |
| distribution\_policy\_zones | The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region | list(string) | `[]` | no |
| update\_policy | The rolling update policy | list(any) | `[]` | no |
| description | An optional textual description of the instance group manager | string | `""` | no |
| named\_ports | Named name and named port | list(any) | `[]` | no |
| wait\_for\_instancesd | Whether to wait for all instances to be created/updated before returning. Note that if this is set to true and the operation does not succeed, Terraform will continue trying until it times out | bool | `false` | no |
| stateful\_disk | Disks created on the instances that will be preserved on instance delete, update, etc. Proactive cross zone instance redistribution must be disabled before you can update stateful disks on existing instance group managers. This can be controlled via the update_policy | list(any) | `[]` | no |
| auto\_healing\_policies | The autohealing policies for this managed instance group. You can specify only one value | list(any) | `[]` | no |
| instance\_template\_id | instance template id | string | `n/a` | yes |
| fixed | fixed number of instances to roll out | number | `0` | yes |
| percent | percentage of instances to roll out | number | `null` | yes |
| canary\_instance\_template\_id | canary instance template id | string | `n/a` | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_group | Instance-group url of managed instance group |
| self\_link | Self-link of managed instance group |
