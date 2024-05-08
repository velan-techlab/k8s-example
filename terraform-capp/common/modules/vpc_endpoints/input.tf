
variable "endpoint_creation" {
  type = bool
  default = false
}

variable "vpc_id" {
  type = string
  default = null
}

variable "service_name" {
  type = string
  default = null  
}

variable "auto_accept_connection" {
  type = bool
  default = true
}

variable "private_dns_enabled" {
  
  type = bool
  default = true

}
variable "gateway_only_route_table_ids" {
  
  type = list(string)
  default = null
}

variable "subnet_ids" {
  type = list(string)
  default = null
}
variable "security_group_ids" {
  type = list(string)
  default = null
}
variable "endpoint_type" {
   type = string
   default = null
}

