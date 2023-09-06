# Define variables for the 'dev' environment here.
variable "example_variable" {
  description = "Example variable for 'dev' environment."
  type        = string
  default     = "dev-default-value"
}

variable "container_env" {
  description = "Environment variables to pass to the container"
  type        = map(string)
  # Optionally, you can set default values here if needed.
  # default     = {
  #   DATABASE_URL = "default-value"
  #   API_KEY      = "default-value"
  # }
}

variable "ssh_file" {
  description = "aws ssh_file path"
  type        = string
}
variable "access_key" {
  description = "aws access_key"
  type        = string
}
variable "secret_access_key" {
  description = "aws secret_access_key"
  type        = string
}
