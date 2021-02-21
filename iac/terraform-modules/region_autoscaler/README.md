## HOW TO USE compute(region autoscaler) module(for terraform version 0.12.21)

```
Autoscalers allow you to automatically scale virtual machine instances in managed
instance groups according to an autoscaling policy that you define.
```

## EXAMPLE Usage

```hcl
module "compute_region_autoscaler" {
  source = "git::ssh://git@bitbucket.org/ovoeng/terraform-module.git//gcp/compute/autoscaler/region_autoscaler?ref=master"

  region_autoscaler_name   = "<AUTOSCALER-NAME>"
  region                   = "asia-southeast2"
  region_autoscaler_target = "<INSTANCE-GROUP-MANAGER-SELF-LINK>"

  project_id  = "<PROJECT-ID>"
  description = "<DESCRIPTION>"

  autoscaler_max_replicas     = 3
  autoscaler_min_replicas     = 2
  autoscaler_cooldown_period  = 120


  # ONLY EXAMPLE
  metric = [
   {
     metric_name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
     metric_filter                     = "resource.type = pubsub_subscription AND resource.label.subscription_id = our-subscription"
     metric_target                     = "<metric_target>"
     metric_type                       = "<metric_type>"
     metric_single_instance_assignment = 65535
   }
  ]

  cpu_utilization = [
    {
      cpu_utilization_target = "0.5"
    }
  ]

  load_balancing_utilization = [
    {
      load_balancing_utilization_target = "0.7"
    }
  ]

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
| timeouts | Timeout configuration for VPC related resources | list | `[{create = "60m" update = "60m" delete = "2h" },]` | no |
| project\_id | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | string | n/a | yes |
| description | An optional description of this resource. The resource must be recreated to modify this field. | string | `"Autoscaler for service"` | no |
| region\_autoscaler\_name | Name of the resource | string | `n/a` | yes |
| region | Region Name | string | `asia-southeast2` | no |
| region\_autoscaler\_target | URL of the managed instance group that this autoscaler will scale | string | `n/a` | yes |
| autoscaler\_max\_replicas | The maximum number of instances that the autoscaler can scale up
to | number | `1` | yes |
| autoscaler\_min_replicas | The minimum number of replicas that the autoscaler can scale
down to | number | `1` | yes |
| autoscaler\_cooldown\_period | The number of seconds that the autoscaler should wait before it
starts collecting information from a new instance | number | `60` | no |
| metric | Configuration parameters of autoscaling based on a custom metric | list | `[]` | no |
| cpu\_utilization | Defines the CPU utilization policy that allows the autoscaler to scale based on the average CPU utilization of a managed instance group | list | `[]` | no |
| load\_balancing\_utilization | Configuration parameters of autoscaling based on a load balancer | list | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| region\_autoscaler\_id | an identifier for the resource with format projects/{{project}}/regions/{{region}}/autoscalers/{{name}} |
| region\_autoscaler\_creation\_timestamp | Creation timestamp in RFC3339 text format |
| region\_autoscaler\_self\_link | The URI of the created resource |
