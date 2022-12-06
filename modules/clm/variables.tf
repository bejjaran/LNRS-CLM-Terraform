
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
  default = ["dmz", "internal"]
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

variable "aws_lb_listener_https_port" {
  description = "Load Balancer HTTPS Listener port"
  type = number
}

variable "aws_private_subnet" {
  description = "The private subnet"
}

variable "aws_public_subnet" {
  description = "The private subnet"
}

variable "aws_public_subnet_az_a" {
  description = "Public subnet AZ A to limit ASG instance deploy to"
}

variable "aws_public_subnet_az_b" {
  description = "Public subnet AZ B to limit ASG instance deploy to"
}

variable "aws_public_subnet_cidr" {
  type = set(string)
  description = "The public subnet CIDR for LB Egress SG"
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

variable "iam_role" {
  description = "IAM Role to be used in the Launch Config for Cloudwatch agent"
}

# RDS Size
variable "rds_size" {
  description = "Instance type for RDS"
}

variable "rds_multi_az_config" {
  description = "Instance multi AZ (true or false)"
  type = bool
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

variable "tag_market" {
  description = "The market for this build; LNRS AWS requirement (e.g. us, uk)"
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

variable "mssql_storage_encrypted" {
  type = bool
  //default = true
}

variable "mssql_allocated_storage" {
  type = number
  //default = 100
}

variable "mssql_max_allocated_storage" {
  type = number
  //default = 200
}

variable "mssql_engine" {
  type = string
  //default = "sqlserver-se"
}

variable "mssql_engine_version" {
  type = string
  //default = "14.00.3281.6.v1"
}
variable "mssql_timezone" {
  type = string
  //default = "US Eastern Standard Time"  
}

# RabbitMQ

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = false
  description = "Enables automatic upgrades to new minor versions for brokers, as Amazon releases updates"
}

variable "deployment_mode" {
  type        = string
  default     = "CLUSTER_MULTI_AZ"
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE, CLUSTER_MULTI_AZ"
}

variable "engine_type" {
  type        = string
  default     = "RabbitMQ"
  description = "Type of broker engine, `ActiveMQ` or `RabbitMQ`"
}

variable "engine_version" {
  type        = string
  default     = "3.10.10"
  description = "The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
}

variable "host_instance_type" {
  type        = string
  default     = "mq.t3.micro"
  description = "The broker's instance type. e.g. mq.t3.micro, mq.m5.large"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
}

variable "log_enabled" {
  type        = bool
  default     = true
  description = "Enables general logging via CloudWatch"
}

variable "maintenance_day_of_week" {
  type        = string
  default     = "SUNDAY"
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
}

variable "maintenance_time_of_day" {
  type        = string
  default     = "06:00"
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
}

variable "maintenance_time_zone" {
  type        = string
  default     = "UTC"
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
}

variable "mq_application_user" {
  type        = string
  default     = "clm-user"
  description = "Application username"
}

variable "mq_application_password" {
  type        = string
  default     = "c44fJDE2-i%vsZvwVk2c"
  description = "Application password"
}


###########

locals { 

  default_tags = {
    "market"        = var.tag_market
    "bu"            = "business services"
    "product"       = "lnrs clm"
    "owner"         = var.tag_owner
    "costcenter"    = "unknown"
    "lifecycle"     = var.environment
    "owner_email"   = var.tag_owner_email
    "support_email" = var.tag_support_email
    "application"   = var.tag_application
    "data"          = "pii"
  }

}