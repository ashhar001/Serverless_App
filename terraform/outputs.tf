# Output for the ID of the VPC created
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Output for the list of IDs of private subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# Output for the list of IDs of public subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
# Output for the API Gateway Stage URL
output "api_gateway_stage_url" {
  description = "The URL of the default API Gateway stage"
  value       = module.api_gateway.default_apigatewayv2_stage_execution_arn
}

# Output for the Lambda function name
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda_function.lambda_function_name
}

# Output for the API Gateway Invoke URL
output "api_gateway_invoke_url" {
  description = "The URL to invoke the API Gateway"
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}

# Output for the API Gateway ID
output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = module.api_gateway.apigatewayv2_api_id
}

# Output for the API Gateway Default Stage ID
output "api_gateway_default_stage_id" {
  description = "The ID of the default API Gateway stage"
  value       = module.api_gateway.default_apigatewayv2_stage_id
}