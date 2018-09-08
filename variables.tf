variable "env" {
  description = "Environment we are running in"
  default     = "default"
}

variable "name" {
  description = "Name of elb"
}

variable "vpc_id" {
  description = "VPC id for security rules"
}

variable "logging_enabled" {
  description = "Enable logging"
  default     = false
}

variable "subnets" {
  type        = "list"
  description = "Subnets for LB"
}

variable "security_groups" {
  type        = "list"
  description = "Security Groups for LB"
}

variable "internal" {
  description = "Toggle internal load balancer"
  default     = false
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type        = "list"
  default     = []
}

variable "https_listeners_count" {
  description = "A manually provided count/length of the https_listeners list of maps since the list cannot be computed."
  default     = 0
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type        = "list"
  default     = []
}

variable "http_tcp_listeners_count" {
  description = "A manually provided count/length of the http_tcp_listeners list of maps since the list cannot be computed."
  default     = 0
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = "list"
  default     = []
}

variable "target_groups_count" {
  description = "A manually provided count/length of the target_groups list of maps since the list cannot be computed."
  default     = 0
}
