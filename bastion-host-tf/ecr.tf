resource "aws_ecr_repository" "frontend_repo" {
  name                 = "frontend"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Environment = "var.environment"
    Project     = "var.project_name"
    name        = "frontend"
  }
}




resource "aws_ecr_repository" "backend_repo" {
  name                 = "backend"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Environment = "var.environment"
    Project     = "var.project_name"
    name        = "backend"
  }
}
