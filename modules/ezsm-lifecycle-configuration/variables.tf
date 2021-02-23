variable "github_config" {
  type = object({
    username = string
    email    = string
  })
  default     = null
  description = "Username and e-mail for configuring GitHub user"
}

variable "auto_stop" {
  type = object({
    idle_time = number
  })
  default     = { idle_time = 3600 }
  description = "Amount of idle time (in seconds) before stopping a notebook instance"
}

variable "stop_at" {
  type = object({
    stop_time = string
  })
  default     = null
  description = "The time at which to stop the notebook instance"
}

variable "time_to_live" {
  type = object({
    duration = string
  })
  default     = null
  description = "The amount of time for the instance to run"
}

variable "ngrok_ssh" {
  type = object({
    authtoken   = string
    public_keys = list(string)
  })
  default     = null
  description = "Authentication information for connecting to your instance with ngrok"
}

variable "on_start" {
  type        = list(string)
  default     = []
  description = "A list of scripts to run on instance start"
}

variable "on_create" {
  type        = list(string)
  default     = []
  description = "A list of scripts to run on instance creation"
}
