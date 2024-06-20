# VPC CIDR
variable "cidr_block" {
  default = "10.0.0.0/16"
}

# AMI which ubuntun and london eu-west 2 region
variable "AMI-ubuntu" {
  default = "ami-0eb260c4d5475b901"
}

variable "instanceType-t2-medium" {
  default = "t2.medium"
}

variable "instance-count" {
  default = 3
}