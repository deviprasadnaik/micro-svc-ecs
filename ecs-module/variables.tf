variable "ClusterPrefix" {
  type = string
}

variable "enable_codebuild" {
  type    = bool
  default = false
}

variable "app_name" {
  type = string
}

variable "enable_ssl" {
  type    = bool
  default = false
}

variable "codebuild_env_config" {
  type = object({
    compute_type = string
    image        = string
    type         = string
  })
}

variable "cluster-id" {
  type = string
}

variable "cluster-name" {
  type = string
}

variable "service-configuration" {
  type = object({
    launch_type      = string
    subnets          = list(string)
    assign_public_ip = bool
    cpu              = number
    memory           = number
    repository_url   = string
  })
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
    appProtocol   = string
    }
  ))
}

variable "prefix_list_ids" {
  type = list(string)
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "alb_subnet_ids" {
  type = list(string)
}

variable "alb_sg_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "codecommit_config" {
  type = object({
    RepositoryName = optional(string, null)
    BranchName     = optional(string, null)
  })
  default = {}
}
