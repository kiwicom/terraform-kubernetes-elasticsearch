// original chart -> https://github.com/elastic/helm-charts/tree/master/elasticsearch
resource "helm_release" "elasticsearch" {
  name      = local.full_name_override
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
    name  = "masterService"
    value = local.master_service
  }

  dynamic "set" {
    for_each = var.es_config

    content {
      type  = "string"
      name  = "esConfig.${set.key}"
      value = var.es_config[set.key]
    }
  }

  set {
    name  = "protocol"
    value = var.protocol
  }

  set {
    name  = "httpPort"
    value = var.http_port
  }

  dynamic "set" {
    for_each = var.common_annotations

    content {
      type  = "string"
      name  = "commonAnnotations.\"${set.key}\""
      value = var.common_annotations[set.key]
    }
  }

  set {
    type  = "string"
    name  = "roles.master"
    value = local.roles["master"]
  }

  set {
    type  = "string"
    name  = "roles.data"
    value = local.roles["data"]
  }

  set {
    type  = "string"
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
