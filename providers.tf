provider "aws" { 
    region  = var.APP_REGION
    profile = "my-profile"
}

terraform {
  backend "s3" {
    bucket  = "pixelapp-secrets-terraform"
    key     = "terraform.tfstate"
    region  = "eu-central-1"
    profile = "my-profile"
    encrypt = true
  }
}