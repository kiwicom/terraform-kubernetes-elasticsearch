locals {
  // Elasticsearch monitoring related local var
  prefixed_node_group = (var.node_group != "") ? "-${var.node_group}" : var.node_group
}

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

  dynamic "set" {
    for_each = var.image_pull_secrets

    content {
      name  = "imagePullSecrets[${set.key}].name"
      value = var.image_pull_secrets[set.key]
    }
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

  dynamic "set" {
    for_each = var.tolerations

    content {
      name  = "tolerations[${set.key}].key"
      value = var.tolerations[set.key].key
    }
  }

  dynamic "set" {
    for_each = var.tolerations

    content {
      name  = "tolerations[${set.key}].operator"
      value = var.tolerations[set.key].operator
    }
  }

  dynamic "set" {
    for_each = var.tolerations

    content {
      name  = "tolerations[${set.key}].value"
      value = var.tolerations[set.key].value
    }
  }

  dynamic "set" {
    for_each = var.tolerations

    content {
      name  = "tolerations[${set.key}].effect"
      value = var.tolerations[set.key].effect
    }
  }

  dynamic "set" {
    for_each = var.node_selector

    content {
      type  = "string"
      name  = "nodeSelector.${set.key}"
      value = var.node_selector[set.key]
    }
  }

  set {
    name  = "esJavaOpts"
    value = var.es_java_opts
  }

  set {
    name  = "extraVolumes"
    value = var.extra_volumes
  }

  set {
    name  = "extraContainers"
    value = var.extra_containers
  }

  dynamic "set" {
    for_each = var.keystore

    content {
      name  = "keystore[${set.key}].secretName"
      value = var.keystore[set.key]
    }
  }
}

// DataDog monitors definitions

resource "datadog_monitor" "es_ready_status_check_slack" {
  count              = var.es_monitoring ? 1 : 0
  name               = "ElasticSearch does not meet desired number of running StatefulSets."
  type               = "metric alert"
  message            = <<EOF
{{#is_alert}}{{/is_alert}}{{#is_alert_recovery}}{{/is_alert_recovery}} 
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Cluster: ${var.cluster_name}${local.prefixed_node_group}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_5m):avg:kubernetes_state.statefulset.replicas_desired{statefulset:${var.cluster_name}${local.prefixed_node_group}} - avg:kubernetes_state.statefulset.replicas_ready{statefulset:${var.cluster_name}${local.prefixed_node_group}} > 1"

  thresholds = {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false

  tags = ["team:platform"]
}

resource "datadog_monitor" "es_ready_status_check_pd" {
  count              = var.es_monitoring ? 1 : 0
  name               = "ElasticSearch does not meet desired number of running StatefulSets."
  type               = "metric alert"
  message            = <<EOF
{{#is_alert}}{{/is_alert}}{{#is_alert_recovery}}{{/is_alert_recovery}} 
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel} ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}
Cluster: ${var.cluster_name}${local.prefixed_node_group}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):avg:kubernetes_state.statefulset.replicas_desired{statefulset:${var.cluster_name}${local.prefixed_node_group}} - avg:kubernetes_state.statefulset.replicas_ready{statefulset:${var.cluster_name}${local.prefixed_node_group}} > 1"

  thresholds = {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data    = false

  tags = ["team:platform"]
}

resource "datadog_monitor" "es_disk_usage_check" {
  count              = (var.es_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name               = "ElasticSearch host high disk usage."
  type               = "metric alert"
  message            = <<EOF
{{#is_warning}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}{{/is_warning}}
{{#is_warning_recovery}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}{{/is_warning_recovery}}
{{#is_alert}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel} ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}"{{/is_alert}}
{{#is_alert_recovery}}Notify: ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}"{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):( 1 - ( sum:elasticsearch.fs.total.available_in_bytes{cluster_name:${var.cluster_name}} by {host} / sum:elasticsearch.fs.total.total_in_bytes{cluster_name:${var.cluster_name}} by {host} ) ) * 100 > 85"
  thresholds = {
    warning           = 75
    warning_recovery  = 70
    critical          = 85
    critical_recovery = 75
  }

  notify_no_data    = false

  tags = ["team:platform"]
}

resource "datadog_monitor" "es_heap_usage_check" {
  count              = (var.es_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name               = "ElasticSearch jvm.heap usage."
  type               = "metric alert"
  message            = <<EOF
{{#is_warning}}{{/is_warning}}
{{#is_warning_recovery}}{{/is_warning_recovery}}
{{#is_alert}}{{/is_alert}}
{{#is_alert_recovery}}{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel} ${var.monitoring_pager_duty_working_hours} ${var.monitoring_pager_duty_team_specific}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):avg:jvm.mem.heap_in_use{cluster_name:${var.cluster_name}} by {host} > 85"

  thresholds = {
    warning           = 75
    warning_recovery  = 70
    critical          = 85
    critical_recovery = 75
  }

  notify_no_data    = false

  tags = ["team:platform"]
}
