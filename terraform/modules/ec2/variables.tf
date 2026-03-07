variable "dynamodb_table_arn" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "alb_sg_id" {}
variable "ami_id" {}
variable "instance_type" { default = "t2.micro" }
variable "key_name" {}
variable "jar_s3_bucket" {}
variable "jar_s3_key" {}