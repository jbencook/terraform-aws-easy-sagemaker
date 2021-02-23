variable "repository_url" {
  type        = string
  description = "The clone URL for the repository"
}

variable "name" {
  type        = string
  description = "The name of the code repository"
  default     = null
}

variable "auth" {
  type = object({
    username = string
    password = string
  })
  sensitive   = true
  default     = null
  description = "Username and password to authenticate private code repositories"
}
