# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "EC2-${var.project_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach Amazon S3 Full Access Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile-${var.project_name}"
  role = aws_iam_role.ec2_role.name
}

# Custom IAM Policy for S3 Bucket Access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.project_name}-S3AccessPolicy"
  description = "Policy granting access to the existing S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "${aws_s3_bucket.attachments.arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.attachments.arn}/*"
      }
    ]
  })
}

# Attach the custom S3 policy to the EC2 IAM Role
resource "aws_iam_role_policy_attachment" "custom_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Update EC2 instance to use the IAM Instance Profile
resource "aws_instance" "app_instance" {
  ami                    = var.custom_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.application_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Root block device configuration
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # Disable termination protection
  disable_api_termination = false

  user_data = <<-EOT
    #!/bin/bash
      echo "DB_HOST=${aws_db_instance.mysql_db.address}" | sudo tee /opt/csye6225/.env 
      echo "DB_PORT=3306" | sudo tee -a /opt/csye6225/.env 
      echo "DB_USER=${var.db_username}" | sudo tee -a /opt/csye6225/.env 
      echo "DB_PASSWORD=${var.db_password}" | sudo tee -a /opt/csye6225/.env
      echo "DB_NAME=${var.db_name}" | sudo tee -a /opt/csye6225/.env 
      echo "PORT=${var.application_port}" | sudo tee -a /opt/csye6225/.env 
      echo "S3_BUCKET_NAME=${aws_s3_bucket.attachments.id}" | sudo tee -a /opt/csye6225/.env 
      echo "AWS_REGION=${var.aws_region}" | sudo tee -a /opt/csye6225/.env 

      sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloud-watch.json -s
      sudo systemctl restart webapp.service
    EOT

  tags = {
    Name = "Application-Instance"
  }
  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_security_group.application_sg,
    aws_iam_role_policy_attachment.custom_s3_policy # Ensure IAM policy is attached before EC2 launches
  ]
}
