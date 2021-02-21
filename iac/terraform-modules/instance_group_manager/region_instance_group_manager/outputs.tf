output "region_instance_group_manager_self_link" {
  description = "Self-link of regional managed instance group"
  value       = google_compute_region_instance_group_manager.default.self_link
}

output "region_instance_group_manager_instance_group" {
  description = "Instance-group url of regional managed instance group"
  value       = google_compute_region_instance_group_manager.default.instance_group
}

output "region_instance_group_manager_instance_group_id" {
  description = "Instance-group id of regional managed instance group"
  value       = google_compute_region_instance_group_manager.default.id
}
