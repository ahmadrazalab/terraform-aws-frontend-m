# # provider find the creds in aws cli dir with the vesion specific terraform 
terraform {
  required_version = "v1.9.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.0"
  
  }
}
}

# Configure the AWS Provider cli with region hard code 
provider "aws" {
  region = "us-east-1"
}

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

# Create Security Groups
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances
resource "aws_instance" "app" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "app-instance-${count.index + 1}"
  }
}

resource "aws_instance" "app_tg2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, 0)
  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "app-instance-tg2"
  }
}

# Create ALB
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg1" {
  name     = "tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "tg2" {
  name     = "tg2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:767397928888:certificate/593d3237-3478-407c-87f4-02dec93d7f08" # Change this to your certificate ARN

  default_action {
    type = "forward"

    forward {
      target_group {
        arn   = aws_lb_target_group.tg1.arn
        weight = 50
      }

      target_group {
        arn   = aws_lb_target_group.tg2.arn
        weight = 50
      }
    }
  }
}

# Register instances to target groups
resource "aws_lb_target_group_attachment" "tg1_attachment" {
  count = length(aws_instance.app)

  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg2_attachment" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.app_tg2.id
  port             = 80
}

# Create Auto Scaling Group for tg1
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = [aws_lb_target_group.tg1.arn]

  launch_configuration = aws_launch_configuration.lc.id

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "lc" {
  name          = "launch-configuration"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.ec2_sg.id]
}

# # Create RDS instance
# resource "aws_db_instance" "default" {
#   allocated_storage    = 20
#   max_allocated_storage = 100   # enable storage autoscaling 
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t2.micro"
#   # db_name              = "mydb-m"
#   username             = "admin"
#   password             = "password" # Change this to your preferred password
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
#   publicly_accessible  = false
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   db_subnet_group_name = aws_db_subnet_group.main.name
# }


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  # publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

}


resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "main"
  }
}


