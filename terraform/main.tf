terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "my-terraform-state-tejasvi02" 
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-east-1"           
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}