# the following uses default for quick plan and apply without a pipeline
variable "region" {
  type    = string
}

variable "project_name" {
  type    = string
}

# https://whatismyipaddress.com/
variable "home_ip" {
  type        = string
  description = "ip allowed to call API gateway"
}

variable "environment" {
  type    = string
}
