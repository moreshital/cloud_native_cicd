output "region_autoscaler_id" {
  value       = google_compute_region_autoscaler.default_region_autoscaler.id
  description = "an identifier for the resource with format projects/{{project}}/regions/{{region}}/autoscalers/{{name}}"
}

output "region_autoscaler_creation_timestamp" {
  value       = google_compute_region_autoscaler.default_region_autoscaler.creation_timestamp
  description = "Creation timestamp in RFC3339 text format"
}

output "region_autoscaler_self_link" {
  value       = google_compute_region_autoscaler.default_region_autoscaler.self_link
  description = "The URI of the created resource"
}
