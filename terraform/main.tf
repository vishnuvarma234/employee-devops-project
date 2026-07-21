resource "aws_ecr_repository" "employee_app" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name        = "employee-app"
    Project     = "Employee DevOps Project"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}