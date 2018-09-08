terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

resource "aws_security_group" "alb_source" {
  name        = "${var.name}_alb_source"
  description = "Used as ssh source for ${var.name}_alb_destination policy"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Terraform = "true"
    Name      = "${var.name}_alb_source"
    env       = "${var.env}"
  }
}

module "alb" {
  source = "github.com/terraform-aws-modules/terraform-aws-alb?ref=v3.4.0"

  load_balancer_name        = "${var.name}"
  vpc_id                    = "${var.vpc_id}"
  logging_enabled           = "${var.logging_enabled}"
  subnets                   = ["${var.subnets}"]
  https_listeners           = ["${var.https_listeners}"]
  https_listeners_count     = "${var.https_listeners_count}"
  http_tcp_listeners        = ["${var.http_tcp_listeners}"]
  http_tcp_listeners_count  = "${var.http_tcp_listeners_count}"
  target_groups             = ["${var.target_groups}"]
  target_groups_count       = "${var.target_groups_count}"
  load_balancer_is_internal = "${var.internal}"

  security_groups = [
    "${aws_security_group.alb_source.id}",
    "${var.security_groups}",
  ]

  tags = {
    Terraform = "true"
    env       = "${var.env}"
  }
}

resource "aws_security_group" "alb_destination" {
  count = "${length(var.target_groups)}"

  name        = "${var.name}_alb_destination_${lookup(var.target_groups[count.index], "backend_port")}"
  description = "Allows access from instance ${var.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${lookup(var.target_groups[count.index], "backend_port")}"
    to_port         = "${lookup(var.target_groups[count.index], "backend_port")}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb_source.id}"]
  }

  tags = {
    Terraform = "true"
    Name      = "${var.name}_alb_destination"
    env       = "${var.env}"
  }
}
