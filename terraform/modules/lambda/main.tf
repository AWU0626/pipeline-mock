# configure iam role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "auth-lambda-authorizer-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# attach cloudwatch logs policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# configure lambda function
resource "aws_lambda_function" "authorizer" {
  function_name = "auth-lambda-authorizer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = var.lambda_zip_path

  environment {
    variables = {
      JWT_SECRET = var.jwt_secret
    }
  }
}
