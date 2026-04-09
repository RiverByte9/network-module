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

# subnet data
# list = ["kajal", "kajal2"]

# first lecture used code
# variable "subnet_data" {
#     description = "List of maps containing subnet data (name, cidr, availability_zone)"
#     type        = list(object({
#         #name              = string
#         public          = bool
#         cidr              = string
#         availability_zone = string
#     }))
# }

#will use this public = true component in tfvars not this below code

#   variable "if_public" {
#     description = "Whether the subnet is public or private"
#     type        = bool
#     default     = true #public by default
# }  till 1:18 lecture

## 2nd lecture

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