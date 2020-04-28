output "elasticsearch_endpoint" {
  value = "${var.cluster_name}-${var.node_group}.${var.namespace}.svc.cluster.local:9200"
}
