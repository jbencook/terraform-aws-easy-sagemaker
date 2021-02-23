variable "ngrok_authtoken" {
  type        = string
  sensitive   = true
  description = "Your ngrok Authtoken"
}

variable "ngrok_public_keys" {
  type        = list(string)
  sensitive   = true
  description = "A list of SSH public keys to add to ~/.ssh/authorized_keys on the instance"
}
