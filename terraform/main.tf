########################################
# NETWORKING
########################################

# VPC
resource "aws_vpc" "default_vpc" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(var.common_tags, {
        Name = var.vpc_name
    })
}

# Internet Gateway
resource "aws_internet_gateway" "default_gateway" {
    vpc_id = aws_vpc.default_vpc.id

    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}-ig"
    })
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
    count                   = length(var.vpc_public_subnet_availability_zones)
    cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, count.index)
    vpc_id                  = aws_vpc.default_vpc.id
    map_public_ip_on_launch = var.map_public_ip_on_launch
    availability_zone       = var.vpc_public_subnet_availability_zones[count.index]

    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
    })
}

# Routing
resource "aws_route_table" "default_route_table" {
    vpc_id = aws_vpc.default_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default_gateway.id
    }

    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}-route-table"
    })
}

resource "aws_route_table_association" "default_subnets" {
    count          = length(aws_subnet.public_subnets[*])
    subnet_id      = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.default_route_table.id
}

# Security Group
resource "aws_security_group" "allow_tcp" {
    name        = "${var.db_name}-allow-tcp"
    description = "Allow TCP inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.default_vpc.id

    tags = var.common_tags
}
