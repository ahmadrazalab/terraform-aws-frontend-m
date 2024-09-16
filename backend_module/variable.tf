
# Variables of N.virginia.US
variable "ami_id" {
  default     = "ami-0c2af51e265bd5e0e"
  description = "The AMI ID for the EC2 instances of API"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t3a.small"
}

variable "vpc_id" {
  default     = "vpc-06661c84c2baeb1ad"
  description = "The Default/Custom VPC ID"
}

variable "subnet_ids" {
  description = "A list of subnet IDs Default/Custom"
  type        = list(string)
  default     = ["subnet-015a40d5f423f524a", "subnet-0290c587dafefc1e0", "subnet-0b8b4c5497fa8fd25"]
}

variable "environment" {
  description = "The environment (e.g., prod, dev, staging)"
  type        = string
  default     = "prod"
}

variable "company_name" {
  description = "The name of the company"
  type        = string
  default     = "ahmadraza.in"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal or not"
  type        = bool
  default     = false
}

variable "app_port" {
  description = "The port the application listens on"
  type        = number
  default     = 80
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the ASG"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "The minimum size of the ASG"
  type        = number
  default     = 1
}

variable "user_data_script_path" {
  description = "The path to the user data script"
  type        = string
  default     = "./resources/user-data.sh"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes for the RDS instance"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "The maximum allocated storage in gigabytes for the RDS instance"
  type        = number
  default     = 100
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "app-bucket"
}

# tf wars variables
variable "certificate_arn" {
  description = "The ARN of the ACM certificate to use for the HTTPS listener"
  type        = string
}
