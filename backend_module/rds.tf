
# RDS mysql database 
##############################################################################################################################################################
resource "aws_db_instance" "primary_db" {
  identifier             = "${var.environment}-${var.company_name}-primary-db"
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = "admin"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  deletion_protection    = false # normally its true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.arn

  tags = {
    Name = "app-db"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.environment}-${var.company_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "aws_db_subnet_group"
  }
}


#########################################################################################
# Read Replica of the primary MySQL RDS instance in the same region
resource "aws_db_instance" "read_replica" {
  identifier             = "${var.environment}-${var.company_name}-db-replica"
  replicate_source_db    = aws_db_instance.primary_db.identifier
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name #.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "app-db-read-replica"
  }
}





