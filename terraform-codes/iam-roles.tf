
// EKS Cluster IAM Role
resource "aws_iam_role" "project02-eks_iam_cluster" {
  name = "project02-EKS-IAM-CLUSTER"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// EKS Cluster IAM Policy
resource "aws_iam_role_policy_attachment" "project02-eks_iam_cluster_AmazonEKSClusterPolicy" {
  role = aws_iam_role.project02-eks_iam_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "project02-eks_iam_cluster_AmazonEKSVPCResourceController" {
  role = aws_iam_role.project02-eks_iam_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

// EKS Worker Node IAM Role
resource "aws_iam_role" "project02-eks_iam_nodes" {
  name = "project02-EKS-IAM-WORKERNODE"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// EKS Worker Node IAM Policy
resource "aws_iam_role_policy_attachment" "project02-eks_iam_cluster_AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.project02-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "project02-eks_iam_cluster_AmazonEKS_CNI_Policy" {
  role = aws_iam_role.project02-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "project02-eks_iam_cluster_AmazonEC2ContainerRegistryReadOnly" {
  role = aws_iam_role.project02-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
