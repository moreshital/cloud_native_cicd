variable "timeouts" {
  default = [
    {
      create = "60m"
      update = "60m"
      delete = "2h"
    },
  ]
  description = "(Optional) Timeout configuration for Autoscaler related resources"
  type        = list
}

variable "project_id" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "description" {
  type        = string
  description = "(Required) An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "region_autoscaler_name" {
  description = <<EOQ
  "(Required) Name of the resource. The name must be 1-63 characters long and
  match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first
  character must be a lowercase letter, and all following characters must be a
  dash, lowercase letter, or digit, except the last character, which cannot be
  a dash."
EOQ
  type        = string
}

variable "region" {
  default     = "asia-southeast2"
  description = "(Optional) Region Name"
  type        = string
}

variable "region_autoscaler_target" {
  description = "(Required) URL of the managed instance group that this autoscaler will scale."
}

variable "autoscaler_max_replicas" {
  default     = 1
  description = <<EOQ
  "(Required) The maximum number of instances that the autoscaler can scale up
  to. This is required when creating or updating an autoscaler. The maximum
  number of replicas should not be lower than minimal number of replicas."
EOQ
  type        = number
}

variable "autoscaler_min_replicas" {
  default     = 1
  description = <<EOQ
  "(Required) The minimum number of replicas that the autoscaler can scale
  down to. This cannot be less than 0. If not provided, autoscaler will choose
  a default value depending on maximum number of instances allowed."
EOQ
  type        = number
}

variable "autoscaler_cooldown_period" {
  default     = 60
  description = <<EOQ
  "(Optional) The number of seconds that the autoscaler should wait before it
  starts collecting information from a new instance. This prevents the
  autoscaler from collecting information when the instance is initializing,
  during which the collected usage would not be reliable. The default time
  autoscaler waits is 60 seconds. Virtual machine initialization times might
  vary because of numerous factors. We recommend that you test how long an
  instance may take to initialize. To do this, create an instance and time the
  startup process."
EOQ
  type        = number
}

variable "metric" {
  default     = []
  description = "(Optional) Configuration parameters of autoscaling based on a custom metric."
  type = list(
    object(
      {
        metric_name                       = string
        metric_filter                     = string
        metric_target                     = string
        metric_type                       = string
        metric_single_instance_assignment = number
      }
    )
  )
}

variable "cpu_utilization" {
  default     = []
  description = <<EOQ
  "(Optional) Defines the CPU utilization policy that allows the autoscaler to
  scale based on the average CPU utilization of a managed instance group."
EOQ
  type = list(
    object(
      {
        cpu_utilization_target = string
      }
    )
  )
}

variable "load_balancing_utilization" {
  default     = []
  description = <<EOQ
  "(Optional) Configuration parameters of autoscaling based on a load balancer."
EOQ
  type = list(
    object(
      {
        load_balancing_utilization_target = string
      }
    )
  )
}
