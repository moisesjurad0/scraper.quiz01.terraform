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
