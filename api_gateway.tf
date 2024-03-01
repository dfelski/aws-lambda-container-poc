resource "aws_apigatewayv2_api" "lambda" {
  name          = "lambda"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "docker_image_import"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "docker_image_import" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.docker_image_import.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "docker_image_import" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /import"
  target    = "integrations/${aws_apigatewayv2_integration.docker_image_import.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.docker_image_import.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
