variable "lambda_exec_role_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "invoke_source_arn" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "env_vars" {
  type = map(string)
}

variable "memory_size" {
  type = number
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}
