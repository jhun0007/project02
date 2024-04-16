
resource "aws_eip" "project02-eip" {  
  depends_on = [aws_internet_gateway.project02-internet-gateway]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "project02-eip"
  }
}

resource "aws_nat_gateway" "project02-nat" {  
  allocation_id = aws_eip.project02-eip.id
  subnet_id  = aws_subnet.project02-public-subnet[0].id
  depends_on = [aws_internet_gateway.project02-internet-gateway]

  tags = {
    Name = "project02-nat"
  }
}