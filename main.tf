
# Create ALB
##############################################################################################################################################################
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  # lifecycle {
  #   prevent_destroy = true
  # }

}

# TG1-Primary for ALB
resource "aws_lb_target_group" "tg1" {
  name     = "app-tg1"
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


# TG2-Secondary for ALB
resource "aws_lb_target_group" "tg2" {
  name     = "app-tg2"
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

# HTTP-80 > listner1 redirect from http to https as default listner
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


# HTTPS-443 > listner2 redirect traffic to tg1 and tg2 50/50
# Note is there is no acm certificate this will fail
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"

#     forward {
#       target_group {
#         arn    = aws_lb_target_group.tg1.arn
#         weight = 50
#       }

#       target_group {
#         arn    = aws_lb_target_group.tg2.arn
#         weight = 50
#       }
#     }
#   }
# }

# HTTPS-443 > listner2 redirect traffic to tg1 and tg2 50/50
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn 

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.tg1.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.tg2.arn
        weight = 50
      }
    }
  }
}


# Register instances to target group1 and target group2 with spefied instances (tg1 with 1 ec2 and tg2 with 4 ec2)

resource "aws_lb_target_group_attachment" "tg1_attachment" {
  count = length(aws_instance.app)

  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
  lifecycle {
    ignore_changes = [target_id]
  }
}

resource "aws_lb_target_group_attachment" "tg2_attachment" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.tg2.id
  port             = 80
  lifecycle {
    ignore_changes = [target_id]
  }
}


# Create launch template for application instances ami 
##############################################################################################################################################################
resource "aws_launch_template" "lt" {
  name                 = "app-nest-l-template"
  image_id             = var.ami_id # change this to the ami created from the ec2 user data scripts
  instance_type        = var.instance_type
  vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
  key_name             = "api-key-aws"

  # lifecycle {
  #   create_before_destroy = true
  # }
}



# Create Auto Scaling Group for tg1
##############################################################################################################################################################
resource "aws_autoscaling_group" "asg" {
  name = "pt-b-app-asg"
  desired_capacity    = 1
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [aws_lb_target_group.tg1.arn]
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}



