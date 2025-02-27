locals {
  task_definition = templatefile("${path.module}/task-definition/service.tpl",
    {
      name           = var.app_name
      account_id     = data.aws_caller_identity.current.account_id
      region         = data.aws_region.current.name
      repository_url = var.service-configuration.repository_url == null ? aws_ecr_repository.this["enabled"].repository_url : var.service-configuration.repository_url
      port_mappings  = jsonencode(var.port_mappings)
  })
  buildspec_content = templatefile("${path.module}/buildspec.yaml", {
    account_id     = data.aws_caller_identity.current.account_id
    region         = data.aws_region.current.name
    reponame       = var.service-configuration.repository_url == null ? aws_ecr_repository.this["enabled"].name : "null"
    container_name = var.app_name
  })
}


