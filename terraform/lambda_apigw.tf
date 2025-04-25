# Using Terraform modules to create Lambda function, security groups, and API Gateway

# Lambda Function with VPC Access
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "simple-time-service-${var.environment}"
  description   = "Lambda function running Simple Time Service in a container"

  # Use container image from existing ECR
  create_package = false
  image_uri      = "522814697098.dkr.ecr.us-east-1.amazonaws.com/simple-time-service:latest"
  package_type   = "Image"

  # Configure memory and timeout
  memory_size = 1024
  timeout     = 30

  # Publish version
  publish = true

  # VPC configuration
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.lambda_security_group.security_group_id]

  # Environment variables
  environment_variables = {
    PORT     = "3000"
    NODE_ENV = "production"
  }

  # Attach IAM policies
  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
  number_of_policies = 1

  # Add policy for ECR access
  attach_policy_statements = true
  policy_statements = {
    ecr_access = {
      effect = "Allow",
      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken"
      ],
      resources = ["*"]
    }
  }

  # CloudWatch logs
  cloudwatch_logs_retention_in_days = 30

  # Lambda tags
  tags = {
    Name        = "simple-time-service-${var.environment}"
    Environment = var.environment
  }
}

# Security Group for Lambda
module "lambda_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "lambda-${var.environment}-sg"
  description = "Security group for Lambda function"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]

  tags = {
    Name        = "lambda-${var.environment}-sg"
    Environment = var.environment
  }
}

# API Gateway v2 (HTTP API) - more suitable for Lambda proxy integrations
module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.2.0"

  name          = "simple-time-service-api-${var.environment}"
  description   = "HTTP API Gateway for Simple Time Service"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Disable domain name completely
  create_api_domain_name = false

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api_logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "$default" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 30000
    }
  }

  tags = {
    Name        = "simple-time-service-api-${var.environment}"
    Environment = var.environment
  }
}

# CloudWatch log group for API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/simple-time-service-api-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "simple-time-service-api-logs-${var.environment}"
    Environment = var.environment
  }
}

# Add permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # Allow invocation from any API Gateway method/path
  # The source ARN format: arn:aws:execute-api:region:account-id:api-id/*/*/*
  source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*"
}

