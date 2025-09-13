variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Docker image name"
  type        = string
  default     = "anuragstark/devops-sample-app"
}