# configure api gateway
resource "aws_api_gateway_rest_api" "auth_api" {
  name = "auth-service-api"
}

# configure /verify resource
resource "aws_api_gateway_resource" "verify" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  parent_id   = aws_api_gateway_rest_api.auth_api.root_resource_id
  path_part   = "verify"
}

# configure lambda authorizer
resource "aws_api_gateway_authorizer" "jwt_authorizer" {
  name                   = "jwt-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.auth_api.id
  authorizer_uri         = var.lambda_invoke_arn
  type                   = "TOKEN"
  identity_source        = "method.request.header.Authorization"
}

# allow api gateway to invoke lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.auth_api.execution_arn}/*"
}

# configure GET method on /verify
resource "aws_api_gateway_method" "verify_get" {
  rest_api_id   = aws_api_gateway_rest_api.auth_api.id
  resource_id   = aws_api_gateway_resource.verify.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.jwt_authorizer.id
}

# configure integration to ALB
resource "aws_api_gateway_integration" "verify_integration" {
  rest_api_id             = aws_api_gateway_rest_api.auth_api.id
  resource_id             = aws_api_gateway_resource.verify.id
  http_method             = aws_api_gateway_method.verify_get.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  uri                     = "http://${var.alb_dns_name}/verify"
}

# deploy api gateway
resource "aws_api_gateway_deployment" "auth_deployment" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id

  depends_on = [
    aws_api_gateway_integration.verify_integration
  ]
}

# configure stage
resource "aws_api_gateway_stage" "auth_stage" {
  rest_api_id   = aws_api_gateway_rest_api.auth_api.id
  deployment_id = aws_api_gateway_deployment.auth_deployment.id
  stage_name    = "prod"
}
