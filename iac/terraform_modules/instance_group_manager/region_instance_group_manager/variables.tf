variable "project_id" {
  type        = string
  description = "(Required) The GCP project ID"
}

variable "base_instance_name" {
  description = <<EOQ
  "(Required) The base instance name to use for instances in this group. The
  value must be a valid RFC1035 name. Supported characters are lowercase letters,
  numbers, and hyphens (-). Instances are named by appending a hyphen and a
  random four-character string to the base instance name."
EOQ
}

variable "region" {
  description = "(Required) The region where the managed instance group resides."
  type        = string
  default     = "asia-southeast2"
}

variable "target_size" {
  description = <<EOQ
  "(Optional) The target number of running instances for this managed instance group.
  This value should always be explicitly set unless this resource is attached to an
  autoscaler, in which case it should never be set. Defaults to 0."
EOQ
  default     = 0
}

variable "target_pools" {
  description = <<EOQ
  "(Optional) The target load balancing pools to assign this group to. The full
  URL of all target pools to which new instances in the group are added.
  Updating the target pools attribute does not affect existing instances."
EOQ
  type        = list(string)
  default     = []
}

variable "distribution_policy_zones" {
  description = "The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region."
  type        = list(string)
  default     = []
}

#################
# Rolling Update
#################

variable "update_policy" {
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager.html#rolling_update_policy"
  type = list(object({
    max_surge_fixed              = number
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    minimal_action               = string
    type                         = string
    instance_redistribution_type = string
  }))
  default = []
}

variable "description" {
  default     = ""
  description = "(Optional) An optional textual description of the instance group manager."
  type        = string
}

variable "named_ports" {
  description = "Named name and named port. https://cloud.google.com/load-balancing/docs/backend-service#named_ports"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  default     = false
  type        = bool
}

variable "wait_for_instances" {
  default     = false
  type        = bool
  description = <<EOQ
  "(Optional) Whether to wait for all instances to be created/updated before
  returning. Note that if this is set to true and the operation does not succeed,
  Terraform will continue trying until it times out."
EOQ
}

variable "timeouts" {
  default = [
    {
      create = "60m"
      update = "60m"
      delete = "2h"
    },
  ]
  description = "(Optional) Timeout configuration for Region Instance Group Manager related resources"
  type        = list
}

variable "stateful_disk" {
  default     = []
  type        = list(any)
  description = <<EOQ
  "(Optional, Beta) Disks created on the instances that will be preserved on
  instance delete, update, etc. Proactive cross zone instance redistribution
  must be disabled before you can update stateful disks on existing instance
  group managers. This can be controlled via the update_policy."
EOQ
}

variable "auto_healing_policies" {
  default     = []
  type        = list(any)
  description = <<EOQ
  "(Optional) The autohealing policies for this managed instance group.
  You can specify only one value."
EOQ
}

variable "instance_template_id" {
  description = "instance template id"
}

variable "fixed" {
  description = "fixed number of instances to roll out"
  default     = null
}

variable "percent" {
  description = "percentage of instances to roll out"
  default     = null
}

variable "canary_instance_template_id" {
  description = "canary instance template id"
  default     = null
}
