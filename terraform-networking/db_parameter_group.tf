resource "aws_db_parameter_group" "mysql_param_group" {
  name        = "custom-mysql-param-group"
  family      = "mysql8.0" # Change based on your DB engine version
  description = "Custom Parameter Group for MySQL 8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "max_connections"
    value = "200"
  }

  tags = {
    Name = "mysql-custom-params"
  }
}
