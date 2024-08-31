module "frontend" {
  source = "./frontend_module"
}



module "backend" {
  source          = "./backend_module"
  certificate_arn = "arn:aws:acm:ap-south-1:767397928888:certificate/605b7a5c-1422-4ac4-a2d4-e5b1b5d0b754"
}



module "vpc" {
  source = "./vpc_module"
}
