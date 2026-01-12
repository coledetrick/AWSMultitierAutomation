terraform {
  backend "s3" {
    bucket       = "tf-state-bucket-gha-bucket"
    key          = "AWS/Terraform/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
