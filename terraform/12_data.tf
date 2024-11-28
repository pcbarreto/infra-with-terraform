data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_ecrpublic_authorization_token" "token" {}
data "aws_eks_cluster_auth" "auth" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}
