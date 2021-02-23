variable "policy_arns" {
  type        = set(string)
  default     = []
  description = "A list of IAM policy ARNs to add to the execution role"
}

variable "inline_policies" {
  type        = set(string)
  default     = []
  description = "A list of paths to JSON IAM policies to add to the execution role"
}
