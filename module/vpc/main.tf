# CREATE CUSTOM VPC
resource "aws_vpc" "k8s-proj-vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "k8s-project-vpc"
  }
}