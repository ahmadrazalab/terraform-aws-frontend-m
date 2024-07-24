
# RDS mysql database 
##############################################################################################################################################################
resource "aws_db_instance" "default" {
  identifier             = "app-db-nest" # Set your DB identifier here
  allocated_storage      = 20
  max_allocated_storage  = 100
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  deletion_protection    = false # normally its true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "app-db-nest"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }

}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "aws_db_subnet_group"
  }


}
