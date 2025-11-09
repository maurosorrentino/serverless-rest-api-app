resource "aws_api_gateway_rest_api" "project_name_hello_world_api" {
  name        = "${var.project_name}-hello-world-api"
  description = "REST API returning Hello World"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

module "project_name_hello_world_api_route" {
  source = "./modules/api_gateway"

  rest_api_id       = aws_api_gateway_rest_api.project_name_hello_world_api.id
  http_method       = "GET"
  lambda_invoke_arn = module.project_name_hello_world_lambda.lambda_invoke_arn
  path_part         = "hello-world"
  parent_id         = aws_api_gateway_rest_api.project_name_hello_world_api.root_resource_id

  depends_on = [aws_cloudwatch_log_group.project_name_hello_world_api_log_group, module.project_name_hello_world_lambda,
  aws_api_gateway_account.project_name_hello_world_api_account]
}

# the following is here just to test additional routes
module "project_name_test_api_route" {
  source = "./modules/api_gateway"

  rest_api_id       = aws_api_gateway_rest_api.project_name_hello_world_api.id
  http_method       = "GET"
  lambda_invoke_arn = module.project_name_test_lambda.lambda_invoke_arn
  path_part         = "test"
  parent_id         = aws_api_gateway_rest_api.project_name_hello_world_api.root_resource_id

  depends_on = [aws_cloudwatch_log_group.project_name_hello_world_api_log_group, module.project_name_test_lambda,
  aws_api_gateway_account.project_name_hello_world_api_account]
}

resource "aws_api_gateway_deployment" "project_name_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.project_name_hello_world_api.id

  # force a redeployment when the API definition changes
  triggers = {
    redeployment = sha1(jsonencode(flatten([
      for r in local.api_routes : [r.resource_id, r.method_id, r.integration_id]
    ])))
  }

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
  # Enable the resource lifecycle configuration block create_before_destroy argument in this resource 
  # configuration to properly order redeployments in Terraform. Without enabling create_before_destroy, 
  # API Gateway can return errors such as BadRequestException: Active stages pointing to this deployment must be 
  # moved or deleted on recreation.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "project_name_api_api_stage" {
  deployment_id = aws_api_gateway_deployment.project_name_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.project_name_hello_world_api.id
  stage_name    = var.environment

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.project_name_hello_world_api_log_group.arn
    format = jsonencode({
      requestId = "$context.requestId"
      ip        = "$context.identity.sourceIp"
      caller    = "$context.identity.caller"
      user      = "$context.identity.user"
      status    = "$context.status"
      latency   = "$context.responseLatency"
    })
  }

  depends_on = [aws_cloudwatch_log_group.project_name_hello_world_api_log_group]
}
