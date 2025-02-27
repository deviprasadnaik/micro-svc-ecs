output "cluster-arn" {
  value = aws_ecs_cluster.this.arn
}

output "cluster-id" {
  value = aws_ecs_cluster.this.id
}
