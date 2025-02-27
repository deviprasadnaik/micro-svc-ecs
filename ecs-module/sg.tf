resource "aws_security_group" "this" {
  name        = "${lower(var.ClusterPrefix)}-${var.app_name}-repo"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_from_alb_sg" {
  for_each                 = { for idx, mapping in var.port_mappings : idx => mapping }
  type                     = "ingress"
  from_port                = each.value.hostPort
  to_port                  = each.value.hostPort
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.alb_sg_ids[0]
}

resource "aws_security_group_rule" "allow_https_to_prefix_list" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  prefix_list_ids   = var.prefix_list_ids
}
