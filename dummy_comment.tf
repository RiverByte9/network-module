# # vpc cidr

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
# }

# # vpc name

# variable "vpc_name" {
#   description = "Name for the VPC"
#   type        = string
# }

# ##---------dummy comment-----------------
# # subnet data
# # list = ["kajal", "kajal2"]

# # first lecture used code
# # variable "subnet_data" {
# #     description = "List of maps containing subnet data (name, cidr, availability_zone)"
# #     type        = list(object({
# #         #name              = string
# #         public          = bool
# #         cidr              = string
# #         availability_zone = string
# #     }))
# # }

# #will use this public = true component in tfvars not this below code

# #   variable "if_public" {
# #     description = "Whether the subnet is public or private"
# #     type        = bool
# #     default     = true #public by default
# # }  till 1:18 lecture

# ## 2nd lecture
# ##--------------------------------------
# variable "private_subnet_data" {
#   type = list(object({
#     cidr              = string
#     availability_zone = string
#     prefix            = string
#   }))
#   description = "Map of subnets to create, categorized by type (public/private)"
# }

# variable "public_subnet_data" {
#   type = list(object({
#     cidr              = string
#     availability_zone = string
#     prefix            = string
#   }))
#   description = "Map of subnets to create, categorized by type (public/private)"
# }

# variable "need_nat_gateway" {
#   type        = bool
#   description = "if nat gateway is needed"
#   default     = false
#   #default = true


# }
# variable "need_single_nat_gateway" {
#   type        = bool
#   description = "if you need only1 nat gateway for all private subnets"
#   default     = false
#   #default = true

# }


#----------------------terraform.tfvars-----------
#tfvar is for testing only it will not be used 1:16 lecture
# vpc_cidr = "10.0.0.0/16"
# vpc_name = "my-vpc"

# subnet_data = [{
#     #name              = "public-subnet-1"
#     cidr              = "10.0.1.0/24"
#     public           = true
#     availability_zone = "us-east-1a"
#   },

# {
#     #name              = "public-subnet-2"
#     cidr              = "10.0.2.0/24"
#     public           = true
#     availability_zone = "us-east-1b"

# },
# {
#     #name              = "private-subnet-1"
#     cidr              = "10.0.3.0/24"
#     public           = false
#     availability_zone = "us-east-1c"
# },
# {
#     #name              = "private-subnet-2"
#     cidr              = "10.0.4.0/24"
#     public           = false
#     availability_zone = "us-east-1a"

# }


# ]

# if_public = true
# #if_public = false

#1:25 lecture comment all above code and use below code for testing only

# private_subnet_data = [{
#   cidr              = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
#   },

#   {
#     cidr              = "10.0.2.0/24"
#     availability_zone = "us-east-1b"

#   }
# ]


# public_subnet_data = [{
#   cidr              = "10.0.3.0/24"
#   availability_zone = "us-east-1a"
#   },

#   {
#     cidr              = "10.0.4.0/24"
#     availability_zone = "us-east-1b"

# }]


##------akhilesh lecture----------------------
# list = [ "asd", "fgh", "jkl"]
# map = { "key1" = "value1", "key2" = "value2" }
# object = { "key1" = "value1", "key2" = "value2" }
# subnet_data
# variable "subnet_data" {
#   type = list(object({
#     public              = bool
#     cidr              = string
#     availability_zone = string
#   }))
#   description = "List of subnets to create"
# } 

# variable "If_public_subnet" {
#     type = bool
#     description = "Whether to create public subnets"
#     default = true
# }


# .tfvars -> used to declare the value of the variables declared in the .tf file

# vpc_cidr = "10.0.0.0/16"
# vpc_name = "my-vpc"
# private_subnet_data = [
#   {
#     cidr              = "10.0.1.0/24"
#     availability_zone = "ap-south-1a"
#     prefix            = "private"
#   }
#   , {
#     cidr              = "10.0.2.0/24"
#     availability_zone = "ap-south-1b"
#     prefix            = "private"
#   }

# ]

# public_subnet_data = [
#   {
#     cidr              = "10.0.3.0/24"
#     availability_zone = "ap-south-1a"
#     prefix            = "public"
#   }
#   , {
#     cidr              = "10.0.4.0/24"
#     availability_zone = "ap-south-1b"
#     prefix            = "public"
#   },

# ]

# list = [ "asd", "fgh", "jkl"]
# list =     0, 1, 2
# subnet_data[0].name -> public1
# subnet_data[1].name -> public2
# subnet_data[0].cidr ->   "10.0.1.0/24"
# subnet_data[1].cidr ->   ""10.0.2.0/24" 

# count means how many times to create the resource
# if count =2 -> first index 0, and then index 1

# If_public_subnet = true

# variable value