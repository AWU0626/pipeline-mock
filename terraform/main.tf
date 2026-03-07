#  configure aws
provider "aws" {
  region = var.aws_region
}

# connect dynamodb module
module "dynamodb" {
  source = "./modules/dynamodb"
}

# connect load_balancer module
module "load_balancer" {
  source         = "./modules/load-balancer"
  vpc_id         = var.vpc_id
  subnet_ids     = var.subnet_ids
  ec2_instance_id = module.ec2.instance_id
}

# connect ec2 module
module "ec2" {
  source             = "./modules/ec2"
  dynamodb_table_arn = module.dynamodb.table_arn
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_ids[0]
  alb_sg_id          = module.load_balancer.alb_sg_id
  ami_id             = var.ami_id
  key_name           = var.key_name
  jar_s3_bucket      = var.jar_s3_bucket
  jar_s3_key         = var.jar_s3_key
}

# connect lambda module
module "lambda" {
  source          = "./modules/lambda"
  lambda_zip_path = var.lambda_zip_path
  jwt_secret      = var.jwt_secret
}

# connect api_gateway module
module "api_gateway" {
  source              = "./modules/api-gateway"
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_invoke_arn   = module.lambda.lambda_invoke_arn
  alb_dns_name        = module.load_balancer.alb_dns_name
}
