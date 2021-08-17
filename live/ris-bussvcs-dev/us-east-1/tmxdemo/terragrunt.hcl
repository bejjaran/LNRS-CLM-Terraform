include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.medium"
  ami_id = "ami-0d7d5a0871df79c3c" # 1.0.15
  iam_role = "TAS_Monitoring"
  asg_min = 0
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
  environment           = "tmxdemo"
  environment_short     = "tmxdemo"
  aws_vpc               = "clm-dev"
  aws_region            = "us-east-1"
  aws_availability_zone = "us-east-1a"

  # Define subnets & LB SG Egress CIDR due to differences in subnet naming between regions 
  aws_private_subnet  = "clm-dev-private-us-east-1*"
  aws_public_subnet   = "clm-dev-public-us-east-1*"
  aws_public_subnet_cidr = ["10.245.105.0/28", "10.245.105.16/28", "10.245.105.32/28"]

  # Limit ASG to zones A & B
  aws_public_subnet_az_a   = "subnet-0fc00c141c5c1b21a"
  aws_public_subnet_az_b   = "subnet-05a6a4c353b58fa4f"

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:us-east-1:152186781777:certificate/b0bdd62e-9dd0-4650-8efc-09817e048d3b"
  
  # Tags
  tag_owner_email   = "tas-global@lexisnexisrisk.com"
  tag_support_email = "tas-global@lexisnexisrisk.com"
  tag_market        = "us"

}
