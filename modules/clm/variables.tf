
# Basics
variable "environment" {
  description = "The environment you wish to deploy (e.g. staging, production, dr etc)"
}

variable "environment_short" {
  description = "The short name of the environment you wish to deploy (e.g. stage, prod, dr etc)"
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. eu-west-1)"
}

variable "aws_vpc" {
  description = "The VPC Name you want to deploy to"
}

variable "aws_subnet_types" {
  type = set(string)
  default = ["public", "private"]
  description = "The Types of subnet we need to obtain IDs from (e.g public and private)"
}

variable "aws_availability_zone" {
  description = "The VPC Availability zone you want to use (e.g eu-west-1a)"
}

variable "aws_lb_subnets" {
  type = set(string)
  default = ["eu-west-2a", "eu-west-2b"]
  description = "The subnets you wish to deploy load balancers into (e.g eu-west-1a, eu-west-1b)"
}

variable "certificate_arn" {
  description = "The ARN of the environments SSL Certificate"
}

# Launch Config
variable "instance_size" {
  description = "Instance Size to use in the Launch Config"
}

variable "disk_size" {
  description = "Disk Size to use in the Launch Config"
}

variable "asg_min" {
  description = "Min number of instanes in ASG"
}

variable "asg_max" {
  description = "Maximum number of instanes in ASG"
}

variable "ami_id" {
  description = "AMI ID to be used in the Launch Config"
}

# RDS Size
variable "rds_size" {
  description = "Instance type for RDS"
}
# Tags
variable "tag_application" {
  description = "The name of the application for this build  (e.g bridger)"
  default     = "clm"
}

variable "tag_application_short" {
  description = "The short name of the application for this build (e.g xg5)"
  default     = "lnrs-clm"
}

variable "tag_owner" {
  description = "The name of the owner for this build"
  default     = "TAS"
}

variable "tag_owner_email" {
  description = "The email address of the owner for this build"
  default     = ""
}

variable "tag_support_email" {
  description = "The email address of the team that supports this build"
  default     = ""
}

// Username for the administrator DB user.
variable "mssql_admin_username" {
  type = string
}

// Password for the administrator DB user.
variable "mssql_admin_password" {
  type = string
}

###########

locals { 

  default_tags = {
    "market"        = "business"
    "BusinessUnit"  = "Business Services"
    "Owner"         = var.tag_owner
    "lifecycle"     = var.environment
    "owner_email"   = var.tag_owner_email
    "support_email" = var.tag_support_email
    "product"       = "LNRS CLM"
    "application"   = var.tag_application
    "service"       = "CLM"
    "project"       = "LNRS CLM"
    "c7n:schedule"  = "off"
  }

}