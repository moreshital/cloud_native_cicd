## HOW TO USE compute(instance_template) module(for terraform version 0.12.21)

- Manages a VM instance template resource within GCE.
- This module allows you to create an google_compute_instance_template resource, which is used as the basis for the other instance,
managed, and unmanaged instance groups modules.

## EXAMPLE Usage

```hcl
data "google_compute_image" "image" {
  family  = "ubuntu-minimal-2004-lts"
  project = "ubuntu-os-cloud"
}

# resource "google_compute_address" "ip_address" {
#   name = "external-ip"
# }

module "compute_instance_template" {
  source               = "git::ssh://git@bitbucket.org/ovoeng/terraform-module.git//gcp/compute/instance_template?ref=master"
  name_prefix          = "test"
  description          = "testing"
  instance_description = "testing"
  project_id           = "grovo-dev-core"
  machine_type         = "n1-standard-1"
  labels = {
    environment = "dev"
  }
  metadata = {
    foo = "bar"
  }
  tags                    = ["foo", "bar"]
  can_ip_forward          = false
  metadata_startup_script = "cat /etc/lsb-release"
  region                  = "asia-southeast2"
  enable_display          = false
  enable_shielded_vm      = false
  preemptible             = false
  service_account = {
    scopes = []
    email  = null
  }

  all_disks = [
    {
      source_image        = data.google_compute_image.image.self_link
      disk_size_gb        = 50
      disk_type           = "pd-standard"
      auto_delete         = true
      boot                = true
      disk_name           = "xabcd"
      interface           = null
      mode                = "READ_WRITE"
      interface           = "SCSI"
      type                = "PERSISTENT"
      disk_encryption_key = []
    },
    {
      source_image        = null
      disk_size_gb        = 40
      disk_type           = "pd-standard"
      auto_delete         = true
      boot                = false
      disk_name           = "xxyz"
      interface           = null
      mode                = "READ_WRITE"
      interface           = "SCSI"
      type                = "PERSISTENT"
      disk_encryption_key = []
    }
  ]

  alias_ip_range     = []
  access_config      = []
  network            = "grovo-dev-core"
  subnetwork         = "subnet-app-compute"
  subnetwork_project = "grovo-dev-core"
  network_ip         = ""
}

output "instance_template_self_link" {
  description = "Self-link of instance template. The URI of the created resource."
  value       = module.compute_instance_template.instance_template_self_link
}
```

## Inputs

| Name                                        | Description                                                                                                                                                                                          |     Type     |                   Default                   | Required |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------: | :-----------------------------------------: | :------: |
| labels                                      | Labels, provided as a map                                                                                                                                                                            | map(string)  |                   `<map>`                   |    no    |
| machine\_type                               | Machine type to create, e.g. n1-standard-1                                                                                                                                                           |    string    |              `"n1-standard-1"`              |    no    |
| metadata                                    | Metadata, provided as a map                                                                                                                                                                          | map(string)  |                   `<map>`                   |    no    |
| name\_prefix                                | Name prefix for the instance template                                                                                                                                                                |    string    |                    `n/a`                    |   yes    |
| description                                 | A brief description of this resource                                                                                                                                                                 |    string    | `This template is used to create instances` |    no    |
| tags                                        | Network tags, provided as a list                                                                                                                                                                     | list(string) |                  `<list>`                   |    no    |
| instance\_description                       | A brief description to use for instances created from this template                                                                                                                                  |    string    |           `Instance for service`            |    no    |
| min\_cpu\_platform                          | Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake                                                                  |    string    |                   `null`                    |    no    |
| enable\_display                             | Enable Virtual Displays on this instance. Note: allow_stopping_for_update must be set to true in order to update this field                                                                          |     bool     |                   `false`                   |    no    |
| network\_ip                                 | The private IP address to assign to the instance. If empty, the address will be automatically assigned                                                                                               |    string    |                    `""`                     |    no    |
| alias\_ip\_range                            | An array of alias IP ranges for this network interface. Can only be specified for network interfaces on subnet-mode networks                                                                         |  list(any)   |                    `[]`                     |    no    |
| on\_host\_maintenance                       | Defines the maintenance behavior for this instance                                                                                                                                                   |    string    |                   `null`                    |    no    |
| node\_affinities                            | Specifies node affinities or anti-affinities to determine which sole-tenant nodes your instances and managed instance groups will use as host systems                                                |  list(any)   |                    `[]`                     |    no    |
| guest\_accelerator                          | List of the type and count of accelerator cards attached to the instance                                                                                                                             |  list(any)   |                    `[]`                     |    no    |
| project\_id                                 | The ID of the project in which the resource belongs. If it is not provided, the provider project is used                                                                                             |    string    |                    `n/a`                    |   yes    |
| can\_ip\_forward                            | Enable IP forwarding, for NAT instances for example                                                                                                                                                  |     bool     |                   `false`                   |    no    |
| preemptible                                 | Allow the instance to be preempted                                                                                                                                                                   |     bool     |                   `false`                   |    no    |
| region                                      | Region where the instance template should be created                                                                                                                                                 |    string    |              `asia-southeast2`              |    no    |
| all\_disks | List of maps of all disks | list(any) | `n/a` | yes |
| access\_config                              | Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet                                                                                                           |  list(any)   |                    `[]`                     |    no    |
| shielded\_instance\_config                  | Not used unless enable_shielded_vm is true. Shielded VM configuration for the instance                                                                                                               |    object    |                   `<map>`                   |    no    |
| enable\_shielded\_vm                        | hether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs                                                                               |     bool     |                   `false`                   |    no    |
| service\_account                            | Service account to attach to the instance                                                                                                                                                            |    object    |                   `null`                    |    no    |
| metadata\_startup\_script                   | User startup script to run when instances spin up                                                                                                                                                    |    string    |                    `""`                     |    no    |
| subnetwork\_project                         | The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used                                                                                           |    string    |                    `n/a`                    |   yes    |
| subnetwork                                  | The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided                 |    string    |                    `n/a`                    |   yes    |
| network                                     | The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks                           |    string    |                    `n/a`                    |   yes    |
| instance\_template\_create\_before\_destroy | Create before destroy                                                                                                                                                                                |     bool     |                   `true`                    |    no    |

## Outputs

| Name                                   | Description                                   |
| -------------------------------------- | --------------------------------------------- |
| instance\_template\_name               | Name of instance template                     |
| instance\_template\_self\_link         | Self-link of instance template                |
| instance\_template\_tags               | Tags that will be associated with instance(s) |
| instance\_template\_metadata\_fingerprint | The unique fingerprint of the metadata        |
| instance\_template\_tags\_fingerprint     | The unique fingerprint of the tags            |
| instance\_template\_id | an identifier for the resource with format projects/{{project}}/global/instanceTemplates/{{name}} |
