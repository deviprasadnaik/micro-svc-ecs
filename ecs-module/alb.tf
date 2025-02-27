resource "aws_lb_target_group" "this" {
  name        = "${lower(var.ClusterPrefix)}-${var.app_name}-tg"
  port        = var.port_mappings[0].containerPort
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "this" {
  name               = "${lower(var.ClusterPrefix)}-${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_ids
  subnets            = var.alb_subnet_ids
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.enable_ssl ? 443 : 80
  protocol          = var.enable_ssl ? "HTTPS" : "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
