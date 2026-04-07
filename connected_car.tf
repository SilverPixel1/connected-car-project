###############
#Terraform configuration for connected car project
###############

# Configure the AWS provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


###############
#Variables
############### 

variable "aws_region" {
 description = "AWS region"
 type = string
 default = "eu-central-1"
 }
 
 variable "project_name" {
 description = "Project name"
 type = string
 default = "connected-car"
 }
 
 variable "vpc_cidr" {
 description = "CIDR block for the VPC"
 type = string
 default = "10.0.0.0/16"
 }
 
 variable "availability_zones" {
 description = "Availability Zones to use"
 type = list(string)
 default = ["eu-central-1a", "eu-central-1b"]
 }

##################
#VPC
##################

resource "aws_vpc" "connected_car_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true   

  tags = {
    Name = "${var.project_name}-vpc"
    Project = var.project_name
    Environment = "Development"
    ManagedBy = "Terraform"
  }
}


#################
#Internet gateway
#################   

resource "aws_internet_gateway" "connected_car_igw" {
  vpc_id = aws_vpc.connected_car_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Project = var.project_name
    Environment = "Development"
  }
}

#################
#Public subnets Multi-AZ
#################

resource "aws_subnet" "connected_car_public_subnet" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.connected_car_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index) #checken?
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Project = var.project_name
    Tier = "public"
    Environment = "Development"
  }
}

###################
#Private subnets Multi-AZ
###################

resource "aws_subnet" "connected_car_private_subnet" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.connected_car_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(var.availability_zones)) #checken?
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}" #+1 warum? Weil count.index bei 0 beginnt, aber wir wollen die Subnetze ab 1 nummerieren.
    Project = var.project_name
    Tier = "private"
    Environment = "Development"
  }
}

#################
#Route table for public subnets
#################   
resource "aws_route_table" "connected_car_public_rt" {
  vpc_id = aws_vpc.connected_car_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.connected_car_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
    Project = var.project_name
    Environment = "Development"
  }
}

#################
#Associate public subnets with route table (connect Subnet with Route Table)
#################
resource "aws_route_table_association" "connected_car_public_rt_assoc" {
    count = length(var.availability_zones)    
    subnet_id = aws_subnet.connected_car_public_subnet[count.index].id
    route_table_id = aws_route_table.connected_car_public_rt.id
}


###################
#Output VPC and subnet IDs
###################
output "vpc_id" {
  value = aws_vpc.connected_car_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.connected_car_public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.connected_car_private_subnet[*].id
}   

