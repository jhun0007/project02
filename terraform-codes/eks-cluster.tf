resource "aws_eks_cluster" "project02-eks-cluster" {

    depends_on = [
        aws_iam_role_policy_attachment.project02-eks_iam_cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.project02-eks_iam_cluster_AmazonEKSVPCResourceController
    ]

    name = var.cluster-name
    role_arn = aws_iam_role.project02-eks_iam_cluster.arn
    version = "1.28"

    vpc_config{
        security_group_ids = [aws_security_group.project02-eks_sg_controlplane.id, aws_security_group.project02-eks_sg_nodes.id]
        subnet_ids = flatten([aws_subnet.project02-private-subnet[*].id])
        endpoint_private_access = false
        endpoint_public_access = true
    }

    tags = {
        "Name" = "project02-EKS-CLUSTER"
    }
}