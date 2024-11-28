module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.security_group.security_group_id]

  endpoints = {
    rds = {
      service             = "rds"
      private_dns_enabled = true
      subnet_ids          = module.vpc.database_subnets
      security_group_ids  = [module.security_group.security_group_id]
    }
  }
  tags = local.tags

  depends_on = [
    module.vpc,
    module.security_group
  ]
}