# Lambda
variable "region" {
  description = "name of the region where you are creating the Lambda"
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
variable "iam_policy_path" {
  description = "Path under which to create the IAM policy."
  type        = string
  default     = "/"
}

# S3
variable "s3name" {
  description = "The name of the bucket."
  type        = string
}

variable "archive_type" {
  description = "The type of archive file to create for Lambda packaging."
  type        = string
  default     = "zip"
}

variable "s3_versioning_status" {
  description = "The versioning status for the S3 bucket."
  type        = string
  default     = "Enabled"
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "mfa_delete" {
  description = "Specifies whether MFA delete is enabled in the S3 bucket versioning configuration. Valid values: 'Enabled' or 'Disabled'."
  type        = string
  default     = "Disabled"
}


variable "s3_force_destroy" {
  description = "Specifies whether to forcefully delete all objects when destroying the S3 bucket."
  type        = bool
  default     = false
}

variable "s3_object_lock_enabled" {
  description = "Specifies whether object lock is enabled on the S3 bucket."
  type        = bool
  default     = false
}
