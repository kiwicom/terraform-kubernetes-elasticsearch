output "elasticsearch_endpoint" {
  value = "${local.full_name_override}.${var.namespace}.svc.cluster.local:${var.http_port}"
}
