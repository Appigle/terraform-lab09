variable "availability_zones" {
  description = "List of availability zones to use for subnets"
  type        = map(string)
  default = {
    subnet1 = "us-east-1a"
    subnet2 = "us-east-1b"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = null
} 