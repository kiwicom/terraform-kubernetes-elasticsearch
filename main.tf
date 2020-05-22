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

  dynamic "set" {
    for_each = local.pod_annotations

    content {
      type  = "string"
      name  = "podAnnotations.\"${set.key}\""
      value = local.pod_annotations[set.key]
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
    name  = "image"
    value = var.image
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
    value = local.persistance_enabled
  }

  set {
    name  = "ingress.enabled"
    value = var.ingress.enabled
  }

  dynamic "set" {
    for_each = var.ingress.hosts

    content {
      name  = "ingress.hosts[${set.key}].host"
      value = var.ingress.hosts[set.key].host
    }
  }

  dynamic "set" {
    for_each = var.ingress.hosts

    content {
      name  = "ingress.hosts[${set.key}].path"
      value = var.ingress.hosts[set.key].path
    }
  }

  dynamic "set" {
    for_each = var.ingress.hosts

    content {
      name  = "ingress.hosts[${set.key}].port"
      value = var.ingress.hosts[set.key].port
    }
  }

  dynamic "set" {
    for_each = var.ingress.annotations

    content {
      name  = "ingress.annotations.\"${set.key}\""
      value = var.ingress.annotations[set.key]
    }
  }

  dynamic "set" {
    for_each = var.extra_service_ports.ports

    content {
      name  = "extraServicePorts.ports[${set.key}].name"
      value = var.extra_service_ports.ports[set.key].name
    }
  }

  dynamic "set" {
    for_each = var.extra_service_ports.ports

    content {
      name  = "extraServicePorts.ports[${set.key}].port"
      value = var.extra_service_ports.ports[set.key].port
    }
  }

  dynamic "set" {
    for_each = var.extra_service_ports.ports

    content {
      name  = "extraServicePorts.ports[${set.key}].nodePort"
      value = var.extra_service_ports.ports[set.key].node_port
    }
  }

  dynamic "set" {
    for_each = var.extra_service_ports.ports

    content {
      name  = "extraServicePorts.ports[${set.key}].targetPort"
      value = var.extra_service_ports.ports[set.key].target_port
    }
  }

  dynamic "set" {
    for_each = var.extra_configs

    content {
      name  = "extraConfigs[${set.key}].name"
      value = var.extra_configs[set.key].name
    }
  }

  dynamic "set" {
    for_each = var.extra_configs

    content {
      name  = "extraConfigs[${set.key}].path"
      value = var.extra_configs[set.key].path
    }
  }

  dynamic "set" {
    for_each = var.extra_configs

    content {
      name  = "extraConfigs[${set.key}].config"
      value = var.extra_configs[set.key].config
    }
  }

  set {
    name  = "extraVolumes"
    value = var.extra_volumes
  }

  set {
    name  = "extraContainers"
    value = var.extra_containers
  }
}
