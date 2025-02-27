resource "aws_ecs_service" "this" {
  name            = "${var.ClusterPrefix}-${var.app_name}-service"
  cluster         = var.cluster-id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = var.service-configuration.launch_type

  network_configuration {
    subnets          = var.service-configuration.subnets
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = var.service-configuration.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.app_name
    container_port   = var.port_mappings[0].containerPort
  }

}
