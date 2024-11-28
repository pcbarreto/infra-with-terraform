module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  identifier                     = var.identifier
  instance_use_identifier_prefix = true

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "postgres"
  engine_version       = "16"
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = "db.t4g.micro"

  allocated_storage = 30

  manage_master_user_password = true
  db_name                     = var.db_name
  username                    = var.db_username
  port                        = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1

  parameters = [
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = local.tags

  depends_on = [
    module.vpc
  ]
}