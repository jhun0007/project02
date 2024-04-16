resource "aws_internet_gateway" "project02-internet-gateway" {

  depends_on = [
    aws_vpc.project02-eks-vpc
  ]

  vpc_id = aws_vpc.project02-eks-vpc.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}
