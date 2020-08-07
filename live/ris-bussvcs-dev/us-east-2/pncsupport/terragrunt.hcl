include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.medium"
  ami_id = "ami-088bbb55f492f46a6" # sprint 15
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
  mssql_timezone = "US Eastern Standard Time"

  # Basics
  environment           = "pncsupport"
  environment_short     = "pncsup"
  aws_vpc               = "bridger-dev"
  aws_region            = "us-east-2"
  aws_availability_zone = "us-east-2a"

  # Define subnets & LB SG Egress CIDR due to differences in subnet naming between regions 
  aws_private_subnet  = "bridger-dev-private-us-east-2*"
  aws_public_subnet   = "bridger-dev-public-us-east-2*"
  aws_public_subnet_cidr = ["10.245.94.0/28", "10.245.94.16/28", "10.245.94.32/28"]

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:us-east-2:152186781777:certificate/07e86f6a-92e5-4058-a639-25d9a176bbf1"
  
  # Tags
  tag_owner_email   = "tas-uk@lexisnexisrisk.com"
  tag_support_email = "tas-uk@lexisnexisrisk.com"

}