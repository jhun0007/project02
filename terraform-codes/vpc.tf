resource "aws_vpc" "project02-eks-vpc" {

  cidr_block                       = var.aws_vpc_cidr_block
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "${var.name}-vpc"
  }

}
