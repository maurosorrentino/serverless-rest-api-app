data "archive_file" "project_name_lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/${var.function_name}.zip"
}

resource "aws_lambda_function" "project_name_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.project_name_lambda_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = data.archive_file.project_name_lambda_zip.output_path
  source_code_hash = data.archive_file.project_name_lambda_zip.output_base64sha256

  environment {
    variables = var.env_vars
  }

  depends_on = [aws_iam_role.project_name_lambda_exec_role]
}

resource "aws_lambda_function_event_invoke_config" "project_name_lambda_invoke_config" {
  function_name = aws_lambda_function.project_name_lambda.function_name

  maximum_retry_attempts = 2
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.project_name_lambda.invoke_arn
}
