variable "description" {
  description = "(Optional) A brief description of this resource."
  default     = "This template is used to create instances"
  type        = string
}

variable "instance_description" {
  description = "(Optional) A brief description to use for instances created from this template."
  default     = "Instance for service"
  type        = string
}

variable "min_cpu_platform" {
  description = "(Optional) Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake"
  default     = null
}

variable "enable_display" {
  description = "(Optional) Enable Virtual Displays on this instance. Note: allow_stopping_for_update must be set to true in order to update this field."
  default     = false
  type        = bool
}

variable "network_ip" {
  description = "(Optional) The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  default     = ""
  type        = string
}

variable "alias_ip_range" {
  description = "(Optional) An array of alias IP ranges for this network interface. Can only be specified for network interfaces on subnet-mode networks"
  type = list(
    object(
      {
        ip_cidr_range         = string
        subnetwork_range_name = string
      }
    )
  )
  default = []
}

variable "on_host_maintenance" {
  description = "(Optional) Defines the maintenance behavior for this instance."
  default     = null
}

variable "node_affinities" {
  description = "(Optional) Specifies node affinities or anti-affinities to determine which sole-tenant nodes your instances and managed instance groups will use as host systems."
  type = list(
    object(
      {
        key      = string
        operator = string
        value    = string
      }
    )
  )
  default = []
}

variable "guest_accelerator" {
  description = "(Optional) List of the type and count of accelerator cards attached to the instance"
  type = list(
    object(
      {
        type  = string
        count = string
      }
    )
  )
  default = []
}

variable "project_id" {
  description = "(Required) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  type        = string
}

variable "machine_type" {
  description = <<EOQ
  "Machine type to create, e.g. n1-standard-1.
  To create a machine with a custom type (such as extended memory),
  format the value like custom-VCPUS-MEM_IN_MB like custom-6-20480
  for 6 vCPU and 20GB of RAM."
EOQ
  default     = "n1-standard-1"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = false
  type        = bool
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map
  description = "Labels, provided as a map"
  default     = {}
}

variable "preemptible" {
  type        = bool
  description = "Allow the instance to be preempted"
  default     = false
}

variable "region" {
  type        = string
  description = "Region where the instance template should be created."
  default     = "asia-southeast2"
}

#######
# disk
#######

variable "all_disks" {
  type        = list(any)
  description = "List of maps of all disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name"
}

####################
# network_interface
####################
variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  type        = string
}

variable "subnetwork_project" {
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}

###########
# metadata
###########

variable "metadata_startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map
  description = "Metadata, provided as a map"
  default     = {}
}

##################
# service_account
##################

variable "service_account" {
  type = object(
    {
      email  = string
      scopes = set(string)
    }
  )
  default     = null
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

###########################
# Shielded VMs
###########################
variable "enable_shielded_vm" {
  default     = false
  description = "Whether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs. See https://cloud.google.com/compute/docs/images"
}

variable "shielded_instance_config" {
  description = "Not used unless enable_shielded_vm is true. Shielded VM configuration for the instance."
  type = object(
    {
      enable_secure_boot          = bool
      enable_vtpm                 = bool
      enable_integrity_monitoring = bool
    }
  )

  default = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

###########################
# Public IP
###########################
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(
    object(
      {
        nat_ip       = string
        network_tier = string
      }
    )
  )
  default = []
}
