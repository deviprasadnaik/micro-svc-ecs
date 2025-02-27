resource "aws_codebuild_project" "this" {
  for_each       = var.enable_codebuild ? toset(["enabled"]) : toset([])
  name           = "${lower(var.ClusterPrefix)}-${var.app_name}-build-project"
  description    = "build and deploy custom app"
  build_timeout  = 5
  queued_timeout = 5

  service_role = aws_iam_role.this.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.codebuild_env_config.compute_type
    image                       = var.codebuild_env_config.image
    type                        = var.codebuild_env_config.type
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = local.buildspec_content
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${lower(var.app_name)}-build-project-log"
    }
  }
}
