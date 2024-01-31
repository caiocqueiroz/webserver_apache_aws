terraform {
  backend "s3" {
    bucket = "dev-tf-stated-kqz"
    key = "terraform.tfstate"
    region = "us-east-1"
    
  }
}