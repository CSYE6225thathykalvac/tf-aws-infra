# # IAM Role for EC2
# resource "aws_iam_role" "ec2_role" {
#   name = "EC2-${var.project_name}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# # Attach Amazon S3 Full Access Policy to EC2 Role
# resource "aws_iam_role_policy_attachment" "s3_access" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# # Create IAM Instance Profile for EC2
# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "ec2-instance-profile-${var.project_name}"
#   role = aws_iam_role.ec2_role.name
# }

# # Create a Custom IAM Policy for S3 Access
# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "${var.project_name}-S3FullAccessPolicy"
#   description = "Policy for S3 bucket creation and management"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["s3:CreateBucket", "s3:ListAllMyBuckets"]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:PutBucketPolicy",
#           "s3:PutBucketEncryption",
#           "s3:PutLifecycleConfiguration"
#         ]
#         Resource = [
#           "${aws_s3_bucket.attachments.arn}",
#           "${aws_s3_bucket.attachments.arn}/*"
#         ]
#       }
#     ]
#   })
# }
