# VPC ID
data "aws_vpc" "selected" {
  tags = {
    Name = var.aws_vpc
  }
}

# # Specific Subnets
# data "aws_subnet" "subnets" {
#   for_each = var.aws_subnet_types

#   vpc_id   = data.aws_vpc.selected.id
#   tags = {
#     #Name   = "${var.aws_vpc}-${each.value}-${var.aws_availability_zone}"
#     Name   = "${var.aws_vpc} zone-a ${each.value}"
#   }
# }

# # Private Subnet IDs
# data "aws_subnet_ids" "lb_private" {
#   vpc_id = data.aws_vpc.selected.id
#   tags = {
#     #Name   = "${var.aws_vpc}-private-*"
#     Name   = "${var.aws_vpc} zone-* internal"
#   }
# }

# # Public Subnet IDs
# data "aws_subnet_ids" "lb_public" {
#   vpc_id = data.aws_vpc.selected.id
#   tags = {
#     #Name   = "${var.aws_vpc}-public-*"
#     Name   = "${var.aws_vpc} zone-* dmz"
#   }
# }


# Private Subnet IDs
data "aws_subnet_ids" "lb_private" {
  vpc_id = data.aws_vpc.selected.id
  tags = {
    #Name   = "${var.aws_vpc}-private-*"
    #Name   = "${var.aws_vpc} zone-* internal"
    Name  = var.aws_private_subnet
  }
}

# Public Subnet IDs
data "aws_subnet_ids" "lb_public" {
  vpc_id = data.aws_vpc.selected.id
  tags = {
    #Name   = "${var.aws_vpc}-public-*"
    #Name   = "${var.aws_vpc} zone-* dmz"
    Name  = var.aws_public_subnet
  }
}
