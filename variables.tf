variable "ngrok_auth_token" {
  type      = string
  sensitive = true
}

variable "ngrok_public_keys" {
  type      = list(string)
  sensitive = true
}
