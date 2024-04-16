output "cluster_name" {
  value = aws_eks_cluster.project02-eks-cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.project02-eks-cluster.endpoint
}

output "bastion-publicIP" {
  value = aws_instance.project02-bastion.public_ip
}



output "vpc_id" {
    value = aws_vpc.project02-eks-vpc.id
}

output "private-subnet-2a-id" {
    value = aws_subnet.project02-private-subnet[0].id
}

output "public-subnet-2a-id" {
    value = aws_subnet.project02-public-subnet[0].id
}

output "public-subnet-2c-id" {
    value = aws_subnet.project02-public-subnet[1].id
}