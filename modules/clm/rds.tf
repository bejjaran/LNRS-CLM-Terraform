resource "aws_db_subnet_group" "rds" {
  name        = "${var.tag_application_short}-${var.environment_short}-rds-subnet-group"
  description = "${var.tag_application_short}-${var.environment_short}-rds private subnet group."
  subnet_ids  = data.aws_subnet_ids.lb_private.ids
  tags        = merge(map("Name", "${var.tag_application_short}-${var.environment_short}-rds"), local.default_tags)
}

resource "aws_db_instance" "rds" {
  identifier                            = "${var.tag_application_short}-${var.environment_short}-rds"
  allocated_storage                     = var.mssql_allocated_storage
  max_allocated_storage                 = var.mssql_max_allocated_storage
  storage_encrypted                     = var.mssql_storage_encrypted
  license_model                         = "license-included"
  storage_type                          = "gp2"
  engine                                = var.mssql_engine
  engine_version                        = var.mssql_engine_version
  instance_class                        = var.rds_size
  multi_az                              = false
  username                              = var.mssql_admin_username
  password                              = var.mssql_admin_password
  vpc_security_group_ids                = [aws_security_group.db.id]
  db_subnet_group_name                  = aws_db_subnet_group.rds.id
  timezone                              = var.mssql_timezone
  backup_retention_period               = 30
  backup_window                         = "23:00-02:00"
  copy_tags_to_snapshot                 = true
  skip_final_snapshot                   = false
  final_snapshot_identifier             = "${var.tag_application_short}-${var.environment_short}-rds-final-snapshot"
  monitoring_interval                   = 0
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  auto_minor_version_upgrade            = true
  maintenance_window                    = "Fri:04:20-Fri:05:20"
  deletion_protection                   = true
  tags                                  = merge(map("Name", "${var.environment}-mssql"), local.default_tags)
}
