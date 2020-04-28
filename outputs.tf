output "elasticsearch_endpoint" {
  value = local.full_name_override != "" ? "${local.full_name_override}.${var.namespace}.svc.cluster.local:${var.http_port}" : "${var.cluster_name}-${var.node_group}.${var.namespace}.svc.cluster.local:${var.http_port}"
}
