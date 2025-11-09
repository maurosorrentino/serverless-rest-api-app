resource "aws_cloudwatch_log_group" "project_name_hello_world_api_log_group" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.project_name_hello_world_api.name}"
  retention_in_days = 14
}
