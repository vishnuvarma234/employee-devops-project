#########################################
# VPC
#########################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

#########################################
# ECR
#########################################

output "repository_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.employee_app.name
}

output "repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.employee_app.repository_url
}

#########################################
# ECS
#########################################

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ECS Cluster ARN"
  value       = aws_ecs_cluster.main.arn
}

#########################################
# Load Balancer
#########################################

output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.main.arn
}

#########################################
# Target Group
#########################################

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.ecs.arn
}

#########################################
# CloudWatch
#########################################

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}