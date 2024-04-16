variable "aws_region" {
  default = "ap-northeast-2"
  type = string 
}

variable "name" {
  default = "project02"
  type    = string
}

variable "cluster-name" {
  default = "project02-eks-cluster"
  type    = string
}

variable "aws_vpc_cidr_block" {
    default = "10.2.0.0/16"
    type = string
}

variable "aws_vpc_public_subnets" {
    default = ["10.2.0.0/20", "10.2.16.0/20"]
    type = list(string)
}

variable "aws_vpc_private_subnets" {
    default = ["10.2.64.0/20", "10.2.80.0/20"]
    type = list(string)
}

variable "aws_azs"  {
    default = ["ap-northeast-2a", "ap-northeast-2c"]
    type = list(string)
}