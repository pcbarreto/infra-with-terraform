resource "helm_release" "external-ingress" {
  namespace        = "ingress-nginx"
  create_namespace = true
  name             = "external-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.2"
  wait             = false

  values = [
    <<-EOT
    controller:
      ingressClassResource:
        name: "external-ingress"
      service:
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: external
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
          service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    EOT
  ]

  depends_on = [
    module.eks,
    module.eks.eks_managed_node_groups,
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_pool,
    kubectl_manifest.karpenter_node_class,
    helm_release.aws_load_balancer_controller
  ]
}