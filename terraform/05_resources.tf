module "metrics-server" {
  source  = "lablabs/eks-kube-state-metrics/aws"
  version = "0.8.0"

  k8s_namespace      = var.metrics_server_namespace
  helm_release_name  = "metrics-server"
  helm_repo_url      = "https://kubernetes-sigs.github.io/metrics-server"
  helm_chart_name    = "metrics-server"
  helm_chart_version = var.metrics_server_version

  depends_on = [
    module.eks.eks_managed_node_groups,
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_class,
    kubectl_manifest.karpenter_node_pool
  ]
}

module "kube-state-metrics" {
  source  = "lablabs/eks-kube-state-metrics/aws"
  version = "0.8.0"

  k8s_namespace      = "kube-state-metrics"
  helm_release_name  = "kube-state-metrics"
  helm_repo_url      = "https://prometheus-community.github.io/helm-charts"
  helm_chart_name    = "kube-state-metrics"
  helm_chart_version = var.kube_state_metrics_version

  depends_on = [
    module.eks.eks_managed_node_groups,
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_class,
    kubectl_manifest.karpenter_node_pool
  ]
}

module "prometheus-stack" {
  source  = "lablabs/eks-kube-state-metrics/aws"
  version = "0.8.0"

  k8s_namespace      = var.prometheus_stack_namespace
  helm_release_name  = "prometheus-stack"
  helm_repo_url      = "https://prometheus-community.github.io/helm-charts"
  helm_chart_name    = "kube-prometheus-stack"
  helm_chart_version = var.prometheus_stack_versions

  settings = {
    "kubeStateMetrics.enabled" = false
  }

  depends_on = [
    module.eks.eks_managed_node_groups,
    module.metrics-server,
    module.kube-state-metrics,
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_class,
    kubectl_manifest.karpenter_node_pool
  ]
}
