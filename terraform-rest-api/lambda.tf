module "project_name_hello_world_lambda" {
  source = "./modules/lambda"

  function_name         = "${var.project_name}-hello-world-lambda"
  handler               = "get_hello_world_page.lambda_handler"
  runtime               = "python3.11"
  source_dir            = "../app"
  lambda_exec_role_name = "${var.project_name}-hello-world-lambda-exec-role"
  memory_size           = 128
  invoke_source_arn     = "${aws_api_gateway_rest_api.project_name_hello_world_api.execution_arn}/${var.environment}/GET/hello-world"
  env_vars = {
    LOG_LEVEL  = "20",
    H1_CONTENT = "Hello World"
  }
}

# the following is here just to test additional routes
module "project_name_test_lambda" {
  source = "./modules/lambda"

  function_name         = "${var.project_name}-test-lambda"
  handler               = "get_hello_world_page.lambda_handler"
  runtime               = "python3.11"
  source_dir            = "../app"
  lambda_exec_role_name = "${var.project_name}-test-lambda-exec-role"
  memory_size           = 128
  invoke_source_arn     = "${aws_api_gateway_rest_api.project_name_hello_world_api.execution_arn}/${var.environment}/GET/test"
  env_vars = {
    LOG_LEVEL  = "20",
    H1_CONTENT = "Test"
  }
}
