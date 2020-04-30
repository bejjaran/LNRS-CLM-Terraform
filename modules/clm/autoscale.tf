
# Launch Config
resource "aws_launch_configuration" "web" {

  name_prefix     = "${var.environment}-${var.tag_application_short}-"
  image_id        = var.ami_id
  instance_type   = var.instance_size
  security_groups = ["${aws_security_group.web.id}"]

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
      volume_type = "gp2"
      volume_size = var.disk_size
      delete_on_termination = true
      encrypted = false
  }

  depends_on = [aws_security_group.web]

}

# AutoScaling Group
resource "aws_autoscaling_group" "web" {

  name                 = "${var.environment}-${var.tag_application_short}"
  max_size             = var.asg_max
  min_size             = var.asg_min
  desired_capacity     = var.asg_min
  launch_configuration = aws_launch_configuration.web.name
  target_group_arns    = ["${aws_lb_target_group.web-443.arn}"]
  #vpc_zone_identifier  = ["${data.aws_subnet.subnets["public"].id}"]
  #vpc_zone_identifier  = ["${data.aws_subnet.subnets["dmz"].id}"]
  vpc_zone_identifier  = ["${data.aws_subnet.subnets["internal"].id}"]
  termination_policies = ["OldestInstance"]

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  dynamic "tag" {

    for_each = merge(
        map("Name", "${var.environment}-${var.tag_application_short}"),
        local.default_tags
      )
      
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }

  }

  depends_on = [aws_launch_configuration.web]
}
