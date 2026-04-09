# network-module
# network-module
terraform moduel for aws networking

## Usage Examples

### Example 1: VPC without NAT Gateway

Basic VPC setup with public and private subnets but no NAT gateway (private subnets have no internet access).

```hcl
module "vpc" {
  source = "./network-module"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "dev-vpc"

  public_subnet_data = [
    {
      cidr              = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      prefix            = "public"
    },
    {
      cidr              = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      prefix            = "public"
    }
  ]

  private_subnet_data = [
    {
      cidr              = "10.0.3.0/24"
      availability_zone = "us-east-1a"
      prefix            = "private"
    },
    {
      cidr              = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      prefix            = "private"
    }
  ]

  need_nat_gateway        = false
  need_single_nat_gateway = false
}
```

### Example 2: VPC with Single NAT Gateway

Cost-optimized setup with a single NAT gateway shared across all private subnets.

```hcl
module "vpc" {
  source = "./network-module"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "staging-vpc"

  public_subnet_data = [
    {
      cidr              = "10.0.1.0/24"
      availability_zone = "us-west-2a"
      prefix            = "public"
    },
    {
      cidr              = "10.0.2.0/24"
      availability_zone = "us-west-2b"
      prefix            = "public"
    }
  ]

  private_subnet_data = [
    {
      cidr              = "10.0.3.0/24"
      availability_zone = "us-west-2a"
      prefix            = "app"
    },
    {
      cidr              = "10.0.4.0/24"
      availability_zone = "us-west-2b"
      prefix            = "app"
    }
  ]

  need_nat_gateway        = true
  need_single_nat_gateway = true
}
```

### Example 3: High Availability VPC with Multiple NAT Gateways

Production-ready setup with NAT gateways in each availability zone for high availability.

```hcl
module "vpc" {
  source = "./network-module"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "prod-vpc"

  public_subnet_data = [
    {
      cidr              = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      prefix            = "public"
    },
    {
      cidr              = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      prefix            = "public"
    }
  ]

  private_subnet_data = [
    {
      cidr              = "10.0.3.0/24"
      availability_zone = "us-east-1a"
      prefix            = "app"
    },
    {
      cidr              = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      prefix            = "app"
    }
  ]

  need_nat_gateway        = true
  need_single_nat_gateway = false
}
```

### Example 4: Multi-Tier VPC with Database Subnets

Complete setup with separate subnet tiers for applications and databases.

```hcl
module "vpc" {
  source = "./network-module"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "app-vpc"

  public_subnet_data = [
    {
      cidr              = "10.0.1.0/24"
      availability_zone = "ap-south-1a"
      prefix            = "public"
    },
    {
      cidr              = "10.0.2.0/24"
      availability_zone = "ap-south-1b"
      prefix            = "public"
    }
  ]

  private_subnet_data = [
    {
      cidr              = "10.0.10.0/24"
      availability_zone = "ap-south-1a"
      prefix            = "app"
    },
    {
      cidr              = "10.0.11.0/24"
      availability_zone = "ap-south-1b"
      prefix            = "app"
    },
    {
      cidr              = "10.0.20.0/24"
      availability_zone = "ap-south-1a"
      prefix            = "db"
    },
    {
      cidr              = "10.0.21.0/24"
      availability_zone = "ap-south-1b"
      prefix            = "db"
    }
  ]

  need_nat_gateway        = true
  need_single_nat_gateway = false
}
```