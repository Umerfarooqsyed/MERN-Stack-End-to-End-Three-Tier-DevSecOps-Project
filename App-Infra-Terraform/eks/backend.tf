terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}


  # backend "s3" {
  #   bucket         = "dev-aman-tf-bucket"
  #   region         = "us-east-1"
  #   key            = "eks/terraform.tfstate"
  #   dynamodb_table = "Lock-Files"
  #   encrypt        = true
  # }
