terraform {
  backend "s3" {
    bucket       = "tf-state-bucket-gha-bucket-lab"
    key          = "AWS/Terraform/dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
