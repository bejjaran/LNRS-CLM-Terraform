include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.medium"
  ami_id = "ami-0bf10a9ed76e1244d" # 1.0.15
  asg_min = 1
  asg_max = 1
  disk_size = 100

  # RDS Config
  rds_size = "db.t3.medium"
  rds_multi_az_config = false
  mssql_storage_encrypted = false
  mssql_allocated_storage = 20
  mssql_max_allocated_storage = 50
  mssql_engine = "sqlserver-ex"
  mssql_engine_version = "14.00.3281.6.v1"
  mssql_timezone = "GMT Standard Time"

  # Basics
  environment           = "ukdemo"
  environment_short     = "ukdemo"
  aws_vpc               = "lnrs-clm-prod"
  aws_region            = "eu-west-2"
  aws_availability_zone = "eu-west-2a"

  # Define subnets & LB SG Egress CIDR due to differences in subnet naming between regions 
  aws_private_subnet  = "lnrs-clm-prod-private-eu-west-2*"
  aws_public_subnet   = "lnrs-clm-prod-public-eu-west-2*"
  aws_public_subnet_cidr = ["10.223.128.0/28", "10.223.128.16/28", "10.223.128.32/28"]

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:eu-west-2:485575125510:certificate/73c1f84b-a576-4bfd-a632-c387443aa9e8"
  
  # Tags
  tag_owner_email   = "tas-global@lexisnexisrisk.com"
  tag_support_email = "tas-global@lexisnexisrisk.com"

}
