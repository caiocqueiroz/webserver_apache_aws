terraform {
  backend "s3" {
    bucket = "dev-tf-states-kqz"
    key = "terraform.tfstate"
    region = "us-east-1"
    
  }
}