terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.38.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}