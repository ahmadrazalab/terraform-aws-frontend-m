
# Variables
variable "ami_id" {
  default = "ami-0a0e5d9c7acc336f1"
  description = "The AMI ID for the EC2 instances"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t2.micro"
}

variable "vpc_id" {
  default = "vpc-0383716a205757a78"
  description = "The VPC ID"
}

variable "subnet_ids" {
  description = "A list of subnet IDs"
  type        = list(string)
  default = [ "subnet-088b163111abca9e8", "subnet-014c505f127ee9a23", "subnet-0f40021676c987d5e", "subnet-0e2a5c6f1397b1ab0", "subnet-0f879dd6e0b9508d2", "subnet-078dd16ae97c3a3ec" ]
}
