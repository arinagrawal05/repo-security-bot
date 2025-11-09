terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0.0"   # Old version. Security scanners often flag outdated providers.
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA1234567890VULNERABLE"   # Hardcoded secret for scanner detection
  secret_key = "super-insecure-hardcoded-secret"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "vulnerable-test-bucket-example"
  acl    = "public-read"    # Wide open permissions

  versioning {
    enabled = false         # Disabled versioning often flagged
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "none"   # Not valid and will be flagged
      }
    }
  }

  tags = {
    Environment = "test"
    Sensitive   = "true"
  }
}

resource "aws_security_group" "bad_sg" {
  name        = "insecure-sg"
  description = "Security group with open ingress"
  vpc_id      = "vpc-123456"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Fully open ingress
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # Fully open egress
  }
}
