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
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn    = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-443.arn
  }

  depends_on = [aws_lb.web]
}