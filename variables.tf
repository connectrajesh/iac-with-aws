variable "aws_access_key" {
  description = "Access key for AWS provider"
  default     = "your aws_access_key"
  sensitive   = true
}
variable "aws_secret_key" {
  description = "Secret key for AWS provider"
  sensitive   = true
  default     = "your aws_secret_key"
}
