resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = var.db_engine
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  identifier             = var.db_identifier
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  parameter_group_name   = aws_db_parameter_group.mysql_param_group.name 
  db_subnet_group_name   = aws_db_subnet_group.rds_private_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  skip_final_snapshot    = true

  depends_on = [aws_db_subnet_group.rds_private_subnet_group]

  tags = {
    Name = var.db_identifier
  }
}
