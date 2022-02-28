variable "project_key" {
  description = "Project name or key."
}

variable "environment" {
  description = "Environment."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default = "eu-central-1"
}


variable "hosted_zone" {
  description = "The hosted zone to be used."
}

variable "hosted_zone_id" {
  description = "The hosted zone id to be used."
}


variable "frontend_bucket" {
  description = "The AWS S3 bucket name."
}


variable "cache_default_ttl" {
  description = "Cloudfront's cache default time to live."
  default = 3600
}

variable "cache_max_ttl" {
  description = "Cloudfront's cache maximun time to live."
  default = 86400
}
