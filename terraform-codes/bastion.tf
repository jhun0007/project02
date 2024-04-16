resource "aws_instance" "project02-bastion" {
  //depends_on = [aws_eks_cluster.project02-eks-cluster]

  ami                         = "ami-09a7535106fbd42d5"
  instance_type               = "t2.micro"
  key_name                    = "project02-key"
  // 퍼블릭 IP 활성화
  subnet_id  = aws_subnet.project02-public-subnet[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.project02-bastion-sg.id]
  
  tags = {
    Name = "project02-bastion"
  }
  
}