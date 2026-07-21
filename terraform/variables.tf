variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-north-1"
}

variable "repository_name" {
  description = "Amazon ECR Repository Name"
  type        = string
  default     = "employee-app"
}