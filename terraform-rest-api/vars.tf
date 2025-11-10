# the following uses default for quick plan and apply without a pipeline
variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "terraform-rest-api"
}

# https://whatismyipaddress.com/
variable "home_ip" {
  type        = string
  description = "ip allowed to call API gateway"
  default     = "143.58.253.75"
}

variable "environment" {
  type    = string
  default = "dev"
}
