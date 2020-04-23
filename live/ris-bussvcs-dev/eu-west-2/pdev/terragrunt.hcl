include {
  path = "${find_in_parent_folders()}"
}

inputs = {

  # Launch Config
  instance_size = "t3.large"
  ami_id = ""
  asg_min = 1
  asg_max = 1
  disk_size = 100

  # RDS Instance Type
  rds_size = "db.t3.xlarge"

  # Basics
  environment           = "productdev"
  environment_short     = "pdev"
  aws_vpc               = "Bussvcs-Dev"
  aws_region            = "eu-west-2"
  aws_availability_zone = "eu-west-2a"

  # SSL Certificate
  certificate_arn   = "arn:aws:acm:eu-west-2:152186781777:certificate/94738d88-1de1-47c0-b0fb-e90aa4a7741b"
  
  # Tags
  tag_owner_email   = "tas-uk@lexisnexisrisk.com"
  tag_support_email = "tas-uk@lexisnexisrisk.com"

}
