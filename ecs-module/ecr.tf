resource "aws_ecr_repository" "this" {
  for_each             = var.enable_codebuild ? toset(["enabled"]) : toset([])
  name                 = "${lower(var.ClusterPrefix)}-${var.app_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
