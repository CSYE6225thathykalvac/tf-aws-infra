variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "custom_ami_id" {
  type = string
}

variable "application_port" {
  type = number
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro" # Cheapest option
}

variable "db_identifier" {
  type    = string
  default = "csye6225"
}

variable "db_username" {
  type    = string
  default = "csye6225"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "csye6225"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "rds_subnet_group" {
  type = string
}

variable "project_name" {
  description = "Project Name Prefix"
  type        = string
  default     = "csye6225"
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "domain_name" {
  description = "The base domain name (e.g., your-domain-name.tld)"
  type        = string
}

variable "high_cpu_threshold" {
  type = number
}

variable "low_cpu_threshold" {
  type = number
}

variable "account_id" {
  type = string
}

variable "cli_user" {
  type = string
}