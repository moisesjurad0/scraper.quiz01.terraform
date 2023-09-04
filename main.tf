# Define your infrastructure resources for the 'dev' environment here.

terraform {
  required_providers {
    aws = "~> 3.77.0"
  }
}


resource "aws_ec2_instance" "example" {
  ami                = "ami-01234567890abcdef"
  instance_type      = "t2.micro"
  subnet_id          = var.subnet_id
  security_group_ids = [var.security_group_id]
}

resource "aws_lambda_permission" "example" {
  function_name = var.lambda_function_name
  action        = "lambda:InvokeFunction"
  principal     = "ec2.amazonaws.com"
  source_arn    = aws_ec2_instance.example.arn
}

output "instance_ip" {
  value = aws_ec2_instance.example.public_ip
}
