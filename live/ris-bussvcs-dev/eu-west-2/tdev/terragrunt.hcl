include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.medium"
  ami_id = "ami-0b87098a6c91b71c4" # 2.3.2
  iam_role = "TAS_Monitoring"
  asg_min = 2
  asg_max = 2
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
  environment           = "techdev"
  environment_short     = "tdev"
  aws_vpc               = "Bussvcs-Dev"
  aws_region            = "eu-west-2"
  aws_availability_zone = "eu-west-2a"

  # Define subnets & LB SG Egress CIDR due to differences in subnet naming between regions 
  aws_private_subnet  = "Bussvcs-Dev zone-* internal"
  aws_public_subnet   = "Bussvcs-Dev zone-* dmz"
  aws_public_subnet_cidr = ["10.22.96.0/26", "10.22.96.64/26", "10.22.96.128/26"]

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:eu-west-2:152186781777:certificate/94738d88-1de1-47c0-b0fb-e90aa4a7741b"
  
  # Tags
  tag_owner_email   = "tas-uk@lexisnexisrisk.com"
  tag_support_email = "tas-uk@lexisnexisrisk.com"
  tag_market        = "uk"

}