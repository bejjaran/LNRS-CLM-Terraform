include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.medium"
  ami_id = "ami-061d296181baa0a0c" # 2.3.2
  iam_role = "TAS-Monitoring"
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
  environment           = "usdemo"
  environment_short     = "usdemo"
  aws_vpc               = "lnrs-clm-prod"
  aws_region            = "us-east-2"
  aws_availability_zone = "us-east-2a"

  # Define subnets & LB SG Egress CIDR due to differences in subnet naming between regions 
  aws_private_subnet  = "lnrs-clm-prod-private-us-east-2*"
  aws_public_subnet   = "lnrs-clm-prod-public-us-east-2*"
  aws_public_subnet_cidr = ["10.229.129.0/28", "10.229.129.16/28", "10.229.129.32/28"]

  # Limit ASG to zones A & B
  aws_public_subnet_az_a   = "subnet-04f17bfb1c97fe88a"
  aws_public_subnet_az_b   = "subnet-05a71d2b16109c82a"

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:us-east-2:485575125510:certificate/d5ab77a9-66b0-4f3b-bf83-fe0483f62961"
  
  # Tags
  tag_owner_email   = "tas-global@lexisnexisrisk.com"
  tag_support_email = "tas-global@lexisnexisrisk.com"
  tag_market        = "us"

}
