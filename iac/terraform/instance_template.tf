module "compute_instance_template" {
  source               = "../terraform-modules/instance_template"
  name_prefix          = "widsapp-it"
  description          = "wids instance template"
  instance_description = "wids prd"
  project_id           = var.project_id
  machine_type         = "n1-standard-1"
  labels = {
    purpose = "demo"
  }
  metadata = {
    app = "wids"
  }
  tags                    = ["ssh", "cloud-native-cicd", "http-server"]
  can_ip_forward          = false
  metadata_startup_script = "su - ubuntu -c 'pm2 resurrect' && sudo service nginx restart"
  region                  = "asia-south1"
  enable_display          = false
  enable_shielded_vm      = false
  preemptible             = false


  all_disks = [
    {
      source_image        = data.google_compute_image.image.self_link
      disk_size_gb        = 20
      disk_type           = "pd-standard"
      auto_delete         = true
      boot                = true
      interface           = null
      mode                = "READ_WRITE"
      interface           = "SCSI"
      type                = "PERSISTENT"
      disk_encryption_key = []
    }
  ]

  service_account = {
    scopes = ["cloud-platform"]
    email  = google_service_account.serviceaccount.email
  }

  alias_ip_range     = []
  access_config      = []
  network            = ""
  subnetwork         = var.subnetwork
  subnetwork_project = var.network_project_id
  network_ip         = ""
}
