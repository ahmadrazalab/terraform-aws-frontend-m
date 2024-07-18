# # provider find the creds in aws cli dir with the vesion specific terraform 
# terraform {
#   required_version = "v1.9.2"
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "3.0"
  
#   }
# }
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.58.0"
    }
  }
}


# Configure the AWS Provider cli with region hard code 
provider "aws" {
  region = "us-east-1"
}
