# vpc cidr

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# vpc name

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "private_subnet_data" {
  type = list(object({
    cidr              = string
    availability_zone = string
    prefix            = string
  }))
  description = "Map of subnets to create, categorized by type (public/private)"
}

variable "public_subnet_data" {
  type = list(object({
    cidr              = string
    availability_zone = string
    prefix            = string
  }))
  description = "Map of subnets to create, categorized by type (public/private)"
}

variable "need_nat_gateway" {
  type        = bool
  description = "if nat gateway is needed"
  default     = false
  #default = true


}
variable "need_single_nat_gateway" {
  type        = bool
  description = "if you need only1 nat gateway for all private subnets"
  default     = false
  #default = true

}