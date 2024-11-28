module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_read_write_access_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin"]
  repository_name                   = var.ecr_repository_name
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 15 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 15
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}