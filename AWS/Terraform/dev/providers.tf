terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket       = "tf-state-bucket-gha-bucket"
    key          = "AWS/Terraform/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

