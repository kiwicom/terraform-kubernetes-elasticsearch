// https://github.com/elastic/helm-charts/tree/master/elasticsearch
data "helm_repository" "elastic" {
  name = "elastic"
  url  = "https://helm.elastic.co"
}

// TODO: https://github.com/elastic/helm-charts/tree/master/kibana

// TODO: setup datadog

resource "helm_release" "elasticsearch" {
  name       = "${var.cluster_name}-${var.node_group}"
  repository = data.helm_repository.elastic.metadata[0].name
  chart      = "elasticsearch"
  namespace  = var.namespace
  timeout    = var.helm_install_timeout

  values = [
    file("${path.module}/values/${var.node_group}.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "masterService"
    value = local.master_service
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
}
