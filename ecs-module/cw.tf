resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.app_name}-deploy"
}
