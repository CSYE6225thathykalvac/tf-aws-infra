resource "aws_secretsmanager_secret" "db_password" {
  name       = "rds-db-password-${random_id.secret_suffix.hex}"
  kms_key_id = aws_kms_key.secrets_manager_key.arn
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_"
}


resource "random_id" "secret_suffix" {
  byte_length = 4
}
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({ DB_PASSWORD = random_password.db_password.result })
}

