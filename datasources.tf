locals {
  # Common tags to attach to resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_key
  }
}

data "aws_route53_zone" "primary" {
  name = var.hosted_zone
}
