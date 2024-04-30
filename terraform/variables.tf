variable "db_username" {
  type        = string
  description = "The username for the database"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR block for VPC"
}

variable "common_tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

variable "vpc_public_subnet_availability_zones" {
  type        = list(string)
  description = "Availability zones for each public subnet"
}

variable "region" {
  type        = string
  description = "The region where the resources will be deployed."
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for subnet instances"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
}