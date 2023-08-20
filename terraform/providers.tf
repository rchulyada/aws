terraform {
  required_version = ">= 1.5.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  profile = var.aws_sso_profile
}