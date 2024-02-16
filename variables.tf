variable "aws_region" {
  type = string
}

variable "domain_and_bucket_name" { type = string }

variable "https" {
  type    = bool
  default = false
}

variable "custom_dn" {
  type    = bool
  default = false
}
