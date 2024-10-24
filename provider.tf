terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "hemanthkumar.online"
    key    = "ec2-for-k8-master"
    region = "us-east-1"
    dynamodb_table = "hemanthkumar.online_locking"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}