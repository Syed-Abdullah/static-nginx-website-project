variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name tag prefix for resources"
  type        = string
  default     = "static-nginx-website"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of an EXISTING EC2 key pair (create in AWS console/CLI first, not managed by this config)"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR form, for SSH access (e.g. 103.10.20.30/32). Get yours with: curl -s ifconfig.me"
  type        = string
}
