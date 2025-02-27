resource "aws_cloudwatch_event_rule" "this" {
  for_each    = var.enable_codebuild ? toset(["enabled"]) : toset([])
  name        = "${lower(var.ClusterPrefix)}-${var.app_name}-trigger"
  description = "Trigger CodePipeline on CodeCommit push"
  event_pattern = jsonencode({
    source      = ["aws.codecommit"],
    detail-type = ["CodeCommit Repository State Change"],
    resources   = ["arn:aws:codecommit:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:python-app"],
    detail = {
      event         = ["referenceCreated", "referenceUpdated"]
      referenceType = ["branch"]
      referenceName = ["main"]
    }
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each  = var.enable_codebuild ? toset(["enabled"]) : toset([])
  rule      = aws_cloudwatch_event_rule.this["enabled"].name
  target_id = "CodePipeline"
  arn       = aws_codepipeline.this["enabled"].arn
  role_arn  = aws_iam_role.cloudwatch_events_role.arn
}
