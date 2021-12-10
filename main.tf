locals {
  // Elasticsearch monitoring related local var
  prefixed_node_group = (var.node_group != "") ? "-${var.node_group}" : var.node_group
  keystore            = concat(var.keystore, var.create_snapshot_bucket ? ["gcs-service-account"] : [])
  image_pull_secrets  = concat(var.image_pull_secrets, var.create_snapshot_bucket ? ["gitlab"] : [])
  image               = var.image != "" ? var.image : (var.create_snapshot_bucket ? "eu.gcr.io/kw-registry/platform/elasticsearch-gcs-plugin" : "docker.elastic.co/elasticsearch/elasticsearch")
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
    value = "elasticsearch-flight-events-headless"
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
    value = local.image
  }

  set {
    name  = "imageTag"
    value = var.es_version
  }

  dynamic "set" {
    for_each = local.image_pull_secrets

    content {
      name  = "imagePullSecrets[${set.key}].name"
      value = local.image_pull_secrets[set.key]
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
    value = var.resources.limits.memory
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
    for_each = local.keystore

    content {
      name  = "keystore[${set.key}].secretName"
      value = local.keystore[set.key]
    }
  }
}

// DataDog monitors definitions

resource "datadog_monitor" "es_ready_status_check_slack" {
  count   = var.es_monitoring ? 1 : 0
  name    = "ElasticSearch does not meet desired number of running StatefulSets."
  type    = "metric alert"
  message = <<EOF
{{#is_alert}}{{/is_alert}}{{#is_alert_recovery}}{{/is_alert_recovery}} 
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Cluster: ${var.cluster_name}${local.prefixed_node_group}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_5m):avg:kubernetes_state.statefulset.replicas_desired{statefulset:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} - avg:kubernetes_state.statefulset.replicas_ready{statefulset:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} > 1"

  thresholds = {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "datadog_monitor" "es_ready_status_check_pd" {
  count   = var.es_monitoring ? 1 : 0
  name    = "ElasticSearch does not meet desired number of running StatefulSets."
  type    = "metric alert"
  message = <<EOF
{{#is_alert}}{{/is_alert}}{{#is_alert_recovery}}{{/is_alert_recovery}} 
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}
Cluster: ${var.cluster_name}${local.prefixed_node_group}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):avg:kubernetes_state.statefulset.replicas_desired{statefulset:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} - avg:kubernetes_state.statefulset.replicas_ready{statefulset:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} > 1"

  thresholds = {
    critical          = 1
    critical_recovery = 0
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "datadog_monitor" "es_disk_usage_check" {
  count   = (var.es_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name    = "ElasticSearch host high disk usage."
  type    = "metric alert"
  message = <<EOF
{{#is_warning}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}{{/is_warning}}
{{#is_warning_recovery}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_slack_additional_channel}{{/is_warning_recovery}}
{{#is_alert}}Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}"{{/is_alert}}
{{#is_alert_recovery}}Notify: ${var.monitoring_pager_duty_platform_infra} ${var.monitoring_pager_duty_team_specific}"{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):( 1 - ( sum:elasticsearch.fs.total.available_in_bytes{es_cluster_name:${var.cluster_name},gcp_project_id:${var.gcp_project_id}} by {host} / sum:elasticsearch.fs.total.total_in_bytes{es_cluster_name:${var.cluster_name},gcp_project_id:${var.gcp_project_id}} by {host} ) ) * 100 > 85"
  thresholds = {
    warning           = 75
    warning_recovery  = 70
    critical          = 85
    critical_recovery = 75
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "datadog_monitor" "es_heap_usage_check" {
  count   = (var.es_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name    = "ElasticSearch jvm.heap usage."
  type    = "metric alert"
  message = <<EOF
{{#is_warning}}{{/is_warning}}
{{#is_warning_recovery}}{{/is_warning_recovery}}
{{#is_alert}}{{/is_alert}}
{{#is_alert_recovery}}{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.monitoring_pager_duty_working_hours} ${var.monitoring_pager_duty_team_specific}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_15m):avg:jvm.mem.heap_in_use{cluster_name:${var.cluster_name},gcp_project_id:${var.gcp_project_id}} by {host} > 85"

  thresholds = {
    warning           = 75
    warning_recovery  = 70
    critical          = 85
    critical_recovery = 75
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "datadog_monitor" "es_cpu_usage_check" {
  count   = (var.es_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name    = "ElasticSearch CPU usage."
  type    = "metric alert"
  message = <<EOF
{{#is_warning}}{{/is_warning}}
{{#is_warning_recovery}}{{/is_warning_recovery}}
{{#is_alert}}{{/is_alert}}
{{#is_alert_recovery}}{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
Notify: ${var.monitoring_slack_alerts_channel} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.monitoring_pager_duty_working_hours} ${var.monitoring_pager_duty_team_specific}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_1h):( avg:kubernetes.cpu.user.total{kube_stateful_set:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} / avg:kubernetes.cpu.limits{kube_stateful_set:${var.cluster_name}${local.prefixed_node_group},project:${var.gcp_project_id}} ) * 100 > 90"

  thresholds = {
    warning           = 75
    warning_recovery  = 70
    critical          = 90
    critical_recovery = 75
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "datadog_monitor" "es_cluster_health_check" {
  count   = (var.es_health_monitoring && ((local.prefixed_node_group == "-master") || (local.prefixed_node_group == ""))) ? 1 : 0
  name    = "ElasticSearch cluster health."
  type    = "metric alert"
  message = <<EOF
{{#is_warning}}Notify: ${var.notify_infra_about_health ? var.monitoring_slack_alerts_channel : ""} ${var.monitoring_slack_additional_channel}{{/is_warning}}
{{#is_warning_recovery}}Notify: ${var.notify_infra_about_health ? var.monitoring_slack_alerts_channel : ""} ${var.monitoring_slack_additional_channel}{{/is_warning_recovery}}
{{#is_alert}}Notify: ${var.notify_infra_about_health ? var.monitoring_slack_alerts_channel : ""} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.notify_infra_about_health ? var.monitoring_pager_duty_platform_infra : ""} ${var.monitoring_pager_duty_team_specific}"{{/is_alert}}
{{#is_alert_recovery}}Notify: ${var.notify_infra_about_health ? var.monitoring_pager_duty_platform_infra : ""} ${var.monitoring_pager_duty_team_specific == "" ? var.monitoring_slack_additional_channel : ""} ${var.monitoring_pager_duty_team_specific}"{{/is_alert_recovery}}
[GCP project ${var.gcp_project_id}](https://console.cloud.google.com/home/dashboard?project=${var.gcp_project_id})
Host {{host.name}} in cluster ${var.cluster_name}
ES related [wiki](https://kiwi.wiki/handbook/tooling/elasticsearch/)
EOF

  query = "avg(last_5m):min:elasticsearch.cluster_status{cluster_name:${var.cluster_name},gcp_project_id:${var.gcp_project_id}} < 0.9"

  # Values for health metric:
  # 2 - green
  # 1 - yellow
  # 0 - red
  thresholds = {
    # Delay alerting on warning for as long as possible, to reduce the number of 
    # alerts triggering when a new index with many replicas is created
    warning           = 1.05
    warning_recovery  = 2
    critical          = 0.9
    critical_recovery = 1
  }

  notify_no_data = false

  tags = ["team:platform", "es_cluster_name:${var.cluster_name}", "gcp_project_id:${var.gcp_project_id}"]
}

resource "google_service_account" "sa" {
  count        = var.create_snapshot_bucket ? 1 : 0
  account_id   = "${var.cluster_name}"
  display_name = "${var.cluster_name}"
}

data "google_client_config" "this" {}

module "snapshot_bucket" {
  count = var.create_snapshot_bucket ? 1 : 0

  source  = "kiwicom/storage-bucket/google"
  version = "~> 2.0.0" # version >= 2.0.0 and < 2.1.0, e.g. 2.0.X

  bucket_name = "${var.cluster_name}-snapshots"
  location    = data.google_client_config.this.region
  owner_info = {
    responsible_people          = "platform-team"
    communication_slack_channel = "#plz-platform-infra"
  }
  labels = {
    public = "no"
    env    = "production"
    tribe  = "platform"
  }

  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 50 # in days
      }
    }
  ]

  members_storage_admin = ["serviceAccount:${google_service_account.sa[0].email}"]
}

resource "google_service_account_key" "sa" {
  count = var.create_snapshot_bucket ? 1 : 0

  service_account_id = google_service_account.sa[0].name
}

resource "kubernetes_secret" "es_gcs_service_account" {
  count = var.create_snapshot_bucket ? 1 : 0
  metadata {
    name      = "gcs-service-account"
    namespace = "storage"
  }
  data = {
    "gcs.client.default.credentials_file" = base64decode(google_service_account_key.sa[0].private_key)
  }
}
