resource "random_uuid" "bucket_uuid" {}

resource "aws_s3_bucket" "attachments" {
  bucket = random_uuid.bucket_uuid.result # Generate a unique bucket name

  force_destroy = true # Allows bucket deletion even if it's not empty

  tags = {
    Name        = "AttachmentsBucket"
    Environment = "Production"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "attachments" {
  bucket                  = aws_s3_bucket.attachments.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "attachments" {
  bucket = aws_s3_bucket.attachments.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Define a lifecycle policy for storage class transition
resource "aws_s3_bucket_lifecycle_configuration" "attachments" {
  bucket = aws_s3_bucket.attachments.id

  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
