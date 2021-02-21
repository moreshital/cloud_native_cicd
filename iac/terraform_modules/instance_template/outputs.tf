output "instance_template_self_link" {
  description = "Self-link of instance template. The URI of the created resource."
  value       = google_compute_instance_template.default.self_link
}

output "instance_template_name" {
  description = "Name of instance template"
  value       = google_compute_instance_template.default.name
}

output "instance_template_tags" {
  description = "Tags that will be associated with instance(s)"
  value       = google_compute_instance_template.default.tags
}

output "instance_template_metadata_fingerprint" {
  description = "The unique fingerprint of the metadata"
  value       = google_compute_instance_template.default.metadata_fingerprint
}

output "instance_template_tags_fingerprint" {
  description = "The unique fingerprint of the tags"
  value       = google_compute_instance_template.default.tags_fingerprint
}

output "instance_template_id" {
  description = "an identifier for the resource with format projects/{{project}}/global/instanceTemplates/{{name}}"
  value       = google_compute_instance_template.default.id
}
