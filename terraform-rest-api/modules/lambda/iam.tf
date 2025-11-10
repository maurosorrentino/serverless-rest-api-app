resource "aws_iam_role" "project_name_lambda_exec_role" {
  name = "${var.function_name}_exec_role"

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

resource "aws_iam_policy" "project_name_lambda_policy" {
  name = "${var.function_name}LambdaPushToCloudWatch"
  policy = jsonencode({
      Version= "2012-10-17",
      Statement= [
        {
          Effect= "Allow",
          Action= [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource= "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.function_name}:*"
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "project_name_lambda_basic" {
  role       = aws_iam_role.project_name_lambda_exec_role.name
  policy_arn = aws_iam_policy.project_name_lambda_policy.arn
}

resource "aws_lambda_permission" "project_name_api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.invoke_source_arn

  depends_on = [aws_lambda_function.project_name_lambda]
}
