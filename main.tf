// original chart -> https://github.com/elastic/helm-charts/tree/master/elasticsearch
resource "helm_release" "elasticsearch" {
  name      = var.node_group != "" ? "${var.cluster_name}-${var.node_group}" : var.cluster_name
  chart     = "${path.module}/chart"
  namespace = var.namespace
  timeout   = var.helm_install_timeout

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "nodeGroup"
    value = var.node_group
  }

  set {
    name  = "fullnameOverride"
    value = local.full_name_override
  }

  set {
    name  = "httpPort"
    value = var.http_port
  }

  dynamic "set_string" {
    for_each = var.common_annotations

    content {
      name  = "commonAnnotations.\"${set_string.key}\""
      value = var.common_annotations[set_string.key]
    }
  }

  set_string {
    name  = "roles.master"
    value = local.roles["master"]
  }

  set_string {
    name  = "roles.data"
    value = local.roles["data"]
  }

  set_string {
    name  = "roles.ingest"
    value = local.roles["ingest"]
  }

  set {
    name  = "imageTag"
    value = var.es_version
  }

  set {
    name  = "replicas"
    value = local.replicas
  }

  set {
    name  = "minimumMasterNodes"
    value = local.minimum_master_nodes
  }

  set {
    name  = "terminationGracePeriod"
    value = var.termination_grace_period
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "volumeClaimTemplate.storageClassName"
    value = var.storage_class_name
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = var.storage_size
  }

  set {
    name  = "persistence.enabled"
    value = local.persistanceEnabled
  }
}
