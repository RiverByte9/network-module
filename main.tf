resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

##-----------public subnet-----------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_data)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_data[count.index].cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_data[count.index].availability_zone

  tags = {
    Name = "${var.vpc_name} - public${count.index + 1}"
  }
}

#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_data)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

##-----------private subnet-----------------
resource "aws_subnet" "private" {
  count = length(var.private_subnet_data)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_data[count.index].cidr
  map_public_ip_on_launch = false
  availability_zone       = var.private_subnet_data[count.index].availability_zone

  tags = {
    Name = "${var.vpc_name}-${var.private_subnet_data[count.index].prefix}-${count.index + 1}"
  }
}

# private route table (one per NAT gateway for HA)
resource "aws_route_table" "private" {
  count  = var.need_nat_gateway ? (var.need_single_nat_gateway ? 1 : length(var.public_subnet_data)) : 1
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
  }
}

# subnet association with private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_data)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.need_nat_gateway && !var.need_single_nat_gateway ? aws_route_table.private[count.index % length(aws_route_table.private)].id : aws_route_table.private[0].id
}

# elastic ip for nat gateway
resource "aws_eip" "nat" {
  count = var.need_nat_gateway ? (var.need_single_nat_gateway ? 1 : length(var.public_subnet_data)) : 0

  tags = {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
  }
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  count = var.need_nat_gateway ? (var.need_single_nat_gateway ? 1 : length(var.public_subnet_data)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(var.public_subnet_data)].id

  tags = {
    Name = "${var.vpc_name}-nat-gw-${count.index + 1}"
  }
}

# route for NAT gateway in private route tables
resource "aws_route" "private" {
  count                  = var.need_nat_gateway ? (var.need_single_nat_gateway ? 1 : length(var.public_subnet_data)) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

# resource "aws_vpc" "main" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name = var.vpc_name
#   }

# }



# # resource "aws_subnet" "public" {
# # count = length(var.subnet_data)

# #   vpc_id     = aws_vpc.main.id
# #   cidr_block = var.subnet_data[count.index].cidr
# #   #map_public_ip_on_launch = true
# #   #map_public_ip_on_launch = var.if_public ? true : false
# # # ternary operator -> condition ? true_value : false_value
# #   map_public_ip_on_launch = var.subnet_data[count.index].public ? true : false
# #   availability_zone = var.subnet_data[count.index].availability_zone
# #     tags = {
# #         #Name = "${var.vpc_name} - public1"
# #         #Name = "${var.vpc_name} -${var.if_public ? "public" : "private"}${count.index + 1}"
# #         Name = "${var.vpc_name} - ${var.subnet_data[count.index].public ? "public" : "private"}${count.index + 1}"
# #     } # tf plan 1:20 lecture
# # }

# ##-----------public subnet-----------------
# resource "aws_subnet" "public" {
#   count = length(var.public_subnet_data)

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.public_subnet_data[count.index].cidr
#   map_public_ip_on_launch = true
#   availability_zone       = var.public_subnet_data[count.index].availability_zone

#   tags = {
#     Name = "${var.vpc_name} - public${count.index + 1}"
#   }
# }


# #internet gateway
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "${var.vpc_name}-igw"
#   }
# }

# # public route table
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "${var.vpc_name}-public-rt"
#   }
# }

# # associate public subnets with public route table
# resource "aws_route_table_association" "public" {
#   count          = length(var.public_subnet_data)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }




# ##-----------private subnet-----------------
# resource "aws_subnet" "private" {
#   count = length(var.private_subnet_data)

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.private_subnet_data[count.index].cidr
#   map_public_ip_on_launch = false
#   availability_zone       = var.private_subnet_data[count.index].availability_zone

#   tags = {
#     Name = "${var.vpc_name}-${var.private_subnet_data[count.index].prefix}-${count.index + 1}"
#   }
# }

# # private route table
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "${var.vpc_name}-private-rt"
#   }
# }

# #  subnet association with private route table
# resource "aws_route_table_association" "private" {
#   count          = length(var.private_subnet_data)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# # elastic ip for nat gateway  14:00 to 28 min lecture

# resource "aws_eip" "nat" {
#   #dont consider #count = var.need_nat_gateway && !var.need_single_nat_gateway ? length(var.public_subnet_data) : 1
#   # right #count = var.need_nat_gateway ? var.need_single_nat_gateway ?  1 : 2: 0


#   # this below line work only if public subnet is there
#   count = var.need_nat_gateway ? var.need_single_nat_gateway ? 1 : length(var.public_subnet_data) : 0


#   tags = {
#     Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
#   }
#   # 24:00 lecture tf plan target aws_eip.nat

# }
# resource "aws_nat_gateway" "nat" {
#   count = var.need_nat_gateway ? var.need_single_nat_gateway ? 1 : length(var.public_subnet_data) : 0

#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index % length(var.public_subnet_data)].id

#   tags = {
#     Name = "${var.vpc_name}-nat-gw-${count.index + 1}"
#   }
# }

# #route for the route to table
# resource "aws_route" "private" {
#   count                  = var.need_nat_gateway ? length(var.private_subnet_data) : 0
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.main.id
# } #13.37


# # 31 done