output "instance_group_manager_self_link" {
  description = "Self-link of managed instance group"
  value       = google_compute_instance_group_manager.default.self_link
}

output "instance_group_manager_instance_group" {
  description = "Instance-group url of managed instance group"
  value       = google_compute_instance_group_manager.default.instance_group
}

output "instance_group_manager_instance_group_id" {
  description = "Instance-group id of managed instance group"
  value       = google_compute_instance_group_manager.default.id
}
