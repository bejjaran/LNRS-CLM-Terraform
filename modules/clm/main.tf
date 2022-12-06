terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}

provider "aws" {
  region  = var.aws_region
  version = "2.33.0"
}

##################
# Load Balancers #
##################
# ALB (Web)
resource "aws_lb" "web" {
  name                       = "alb-${var.tag_application_short}-${var.environment_short}-web"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = data.aws_subnet_ids.lb_public.ids
  security_groups            = ["${aws_security_group.web-lb.id}"]
  tags                       = local.default_tags
  enable_deletion_protection = true
  idle_timeout               = 600

  depends_on = [aws_security_group.web-lb]
}

####################
# LB Target Groups #
####################
# Web
resource "aws_lb_target_group" "web-443" {
  name        = "${var.tag_application_short}-${var.environment_short}-web-443"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.default_tags
  slow_start  = 180

  health_check {
    protocol = "HTTPS"
    matcher = "200,301"
    path = "/cip"
  }

}

#######################
# Public LB Listeners #
#######################
# Web - HTTP
resource "aws_lb_listener" "web-80" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_lb.web]
}

# Web - HTTPs
resource "aws_lb_listener" "web-443" {
  load_balancer_arn  = aws_lb.web.arn
  port               = var.aws_lb_listener_https_port
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn    = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }

  depends_on = [aws_lb.web]
}

########################
# Message Queue Broker #
########################
resource "aws_mq_broker" "mq" {
  broker_name = "mq-${var.tag_application_short}-${var.environment_short}"

  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode            = var.deployment_mode
  host_instance_type         = var.host_instance_type
  publicly_accessible        = var.publicly_accessible
  log_enabled                = var.log_enabled
  encryption_enabled         = var.encryption_enabled
  kms_mq_key_arn             = var.kms_mq_key_arn
  use_aws_owned_key          = var.use_aws_owned_key
  security_groups            = ["${aws_security_group.mq.id}"]
  apply_immediately          = var.apply_immediately
  subnet_ids                 = [var.aws_public_subnet_az_a, var.aws_public_subnet_az_b]

  user {
    username = var.mq_application_user
    password = var.mq_application_password
  }

  logs {
    general = var.log_enabled
   }
}