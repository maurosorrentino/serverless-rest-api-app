resource "aws_api_gateway_resource" "project_name_api_resource" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "project_name_method_api" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.project_name_api_resource.id
  http_method   = var.http_method
  authorization = "NONE" # resource policy blocks access by IP
}

resource "aws_api_gateway_integration" "project_name_lambda_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.project_name_api_resource.id
  http_method             = aws_api_gateway_method.project_name_method_api.http_method
  integration_http_method = "POST"      # method used to invoke the lambda function
  type                    = "AWS_PROXY" # lambda handles req / res
  uri                     = var.lambda_invoke_arn
}

output "resource_id" {
  value = aws_api_gateway_resource.project_name_api_resource.id
}
output "method_id" {
  value = aws_api_gateway_method.project_name_method_api.id
}
output "integration_id" {
  value = aws_api_gateway_integration.project_name_lambda_integration.id
}
