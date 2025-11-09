locals {
  account_id = data.aws_caller_identity.current.account_id

  # this is used in api_gateway.tf to trigger redeployments when API routes change (aws_api_gateway_deployment resource)
  api_routes = [
    module.project_name_hello_world_api_route,
    module.project_name_test_api_route
  ]
}
