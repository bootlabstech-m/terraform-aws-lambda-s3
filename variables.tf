# Lambda
variable "region" {
  description = "where you are creating the Lambda, ap-south-1."
  type        = string
}

variable "role_arn" {
  description = "role_arn for resource creation."
  type        = string
}

variable "name" {
  description = "Unique name for your Lambda Function."
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}


# S3

variable "s3name" {
  description = "The name of the bucket."
  type        = string
}
variable "region" {
  description = "The region where the bucket is created"
  type        = string
}