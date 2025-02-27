resource "aws_ecs_cluster" "this" {
  name = "${lower(var.ClusterPrefix)}-EcsCluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

