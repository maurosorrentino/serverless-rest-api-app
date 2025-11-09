resource "aws_api_gateway_rest_api_policy" "project_name_hello_world_api_resource_policy" {
  rest_api_id = aws_api_gateway_rest_api.project_name_hello_world_api.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "execute-api:Invoke",
        # adjust with * , add more resources or add more statements as needed
        Resource = [
          "${aws_api_gateway_rest_api.project_name_hello_world_api.execution_arn}/${var.environment}/GET/hello-world",
          "${aws_api_gateway_rest_api.project_name_hello_world_api.execution_arn}/${var.environment}/GET/test"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "${var.home_ip}/32"
          }
        }
      }
    ]
  })

  depends_on = [aws_api_gateway_rest_api.project_name_hello_world_api]
}

resource "aws_iam_role" "project_name_hello_world_api_role" {
  name = "APIGatewayCloudWatchLogsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "apigateway.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "project_name_hello_world_api_log_policy" {
  name = "ApiGatewayPushToCloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # all of those permissions are needed otherwise you get an error
          # https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html?utm_source=chatgpt.com#set-up-access-logging-permissions
          # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonAPIGatewayPushToCloudWatchLogs.html
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Resource = [
          aws_cloudwatch_log_group.project_name_hello_world_api_log_group.arn,
          "${aws_cloudwatch_log_group.project_name_hello_world_api_log_group.arn}:*",
          # automatically created by aws api gateway
          "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/apigateway/welcome:*",
          "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/apigateway/welcome:log-stream:*"
        ]
      }
    ]
  })

  depends_on = [aws_cloudwatch_log_group.project_name_hello_world_api_log_group]
}

resource "aws_iam_role_policy_attachment" "project_name_hello_world_cloudwatch_policy" {
  role       = aws_iam_role.project_name_hello_world_api_role.name
  policy_arn = aws_iam_policy.project_name_hello_world_api_log_policy.arn
}

resource "aws_api_gateway_account" "project_name_hello_world_api_account" {
  cloudwatch_role_arn = aws_iam_role.project_name_hello_world_api_role.arn
}
