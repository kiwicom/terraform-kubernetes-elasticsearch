output "elasticsearch_endpoint" {
  value = "${var.protocol}://${local.full_name_override}.${var.namespace}.svc.cluster.local:${var.http_port}"
}
