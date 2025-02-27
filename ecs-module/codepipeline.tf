resource "aws_codepipeline" "this" {
  for_each       = var.enable_codebuild ? toset(["enabled"]) : toset([])
  name           = "${lower(var.ClusterPrefix)}-${var.app_name}-pipeline"
  pipeline_type  = "V2"
  role_arn       = aws_iam_role.codepipeline_role.arn
  execution_mode = "QUEUED"
  artifact_store {
    location = "codepipeline-${data.aws_region.current.name}-acp-${data.aws_caller_identity.current.account_id}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = var.codecommit_config.RepositoryName
        BranchName     = var.codecommit_config.BranchName
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${lower(var.ClusterPrefix)}-${var.app_name}-build-project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster-name
        ServiceName = aws_ecs_service.this.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
