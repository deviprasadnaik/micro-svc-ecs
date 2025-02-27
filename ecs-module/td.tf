resource "aws_ecs_task_definition" "this" {
  family                   = "${var.ClusterPrefix}-${var.app_name}-td"
  container_definitions    = local.task_definition
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = [var.service-configuration.launch_type]
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
