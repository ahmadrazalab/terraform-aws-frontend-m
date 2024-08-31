# creating frontend resources with static sites
module "frontend" {
  source = "./frontend_module"
}


# creating backend resources with ec2 alb
module "backend" {
  source          = "./backend_module"
  certificate_arn = "arn:aws:acm:ap-south-1:767397928888:certificate/605b7a5c-1422-4ac4-a2d4-e5b1b5d0b754"
}


# creating vpc resources for network isolation
module "vpc" {
  source = "./vpc_module"
}


# creating custom resources 
module "temp_resource" {
  source = "./temp_module"
}