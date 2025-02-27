module "ecs-cluster" {
  source                    = "./ecs-module/ecs-cluster"
  ClusterPrefix             = "DevOps"
  enable_container_insights = true
}

module "python-app-deploy" {
  source           = "./ecs-module"
  ClusterPrefix    = "DevOps"
  cluster-name     = split("/", module.ecs-cluster.cluster-arn)[1]
  cluster-id       = module.ecs-cluster.cluster-id
  enable_codebuild = true
  app_name         = "xyz-app"
  enable_ssl       = false
  codebuild_env_config = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }
  codecommit_config = {
    RepositoryName = "xyz-app"
    BranchName     = "main"
  }
  service-configuration = {
    launch_type      = "FARGATE"
    subnets          = data.aws_subnets.PrivateSubnets.ids
    assign_public_ip = true
    cpu              = 256
    memory           = 512
    repository_url   = null
  }
  port_mappings = [{
    containerPort = 5000
    hostPort      = 5000
    protocol      = "tcp"
    appProtocol   = "http"
  }]
  prefix_list_ids    = ["pl-xxxxx"]
  task_role_arn      = data.aws_iam_role.EcsTaskExecRole.arn
  execution_role_arn = data.aws_iam_role.EcsTaskExecRole.arn
  alb_subnet_ids     = data.aws_subnets.selected.ids
  alb_sg_ids         = [data.aws_security_group.default_sg.id]
  vpc_id             = data.aws_vpcs.vpc_id.ids[0]
}

module "jenkins-service" {
  source           = "./ecs-module"
  ClusterPrefix    = "jenkins"
  cluster-name     = split("/", module.ecs-cluster.cluster-arn)[1]
  cluster-id       = module.ecs-cluster.cluster-id
  enable_codebuild = false
  app_name         = "jenkins-app"
  enable_ssl       = false
  codebuild_env_config = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }
  service-configuration = {
    launch_type      = "FARGATE"
    subnets          = data.aws_subnets.PrivateSubnets.ids
    assign_public_ip = true
    cpu              = 256
    memory           = 512
    repository_url   = "jenkins/jenkins:lts"
  }
  port_mappings = [{
    containerPort = 8080
    hostPort      = 8080
    protocol      = "tcp"
    appProtocol   = "http"
    },
    {
      containerPort = 50000
      hostPort      = 50000
      protocol      = "tcp"
      appProtocol   = "http"
  }]
  prefix_list_ids    = ["pl-xxxx"]
  task_role_arn      = data.aws_iam_role.EcsTaskExecRole.arn
  execution_role_arn = data.aws_iam_role.EcsTaskExecRole.arn
  alb_subnet_ids     = data.aws_subnets.selected.ids
  alb_sg_ids         = [data.aws_security_group.default_sg.id]
  vpc_id             = data.aws_vpcs.vpc_id.ids[0]
}

