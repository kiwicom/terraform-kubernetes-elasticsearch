output "elasticsearch_endpoint" {
  value = "${var.protocol}://${local.full_name_override}.${var.namespace}.svc.cluster.local:${var.http_port}"
}

output "snapshot_bucket_name" {
  value = var.create_snapshot_bucket ? module.snapshot_bucket[0].bucket_name : ""
}

output "snapshot_bucket_access_key" {
  value = var.create_snapshot_bucket ? google_service_account_key.sa[0].private_key : ""
  sensitive = true
}
