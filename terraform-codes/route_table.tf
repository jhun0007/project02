resource "aws_route_table" "project02-route-table-public-sub" {

  depends_on = [
    aws_vpc.project02-eks-vpc,
    aws_internet_gateway.project02-internet-gateway
  ]

  vpc_id = aws_vpc.project02-eks-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.project02-internet-gateway.id
  }

  tags = {
    Name = "project02-route-table-public-sub"
  }

}

resource "aws_route_table" "project02-route-table-private-sub" {

  depends_on = [
    aws_vpc.project02-eks-vpc,
    aws_nat_gateway.project02-nat
  ]

  vpc_id = aws_vpc.project02-eks-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.project02-nat.id
  }

  tags = {
    Name = "project02-route-table-private-sub"
  }
}