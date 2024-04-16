// Default SG
resource "aws_default_security_group" "project02-eks-vpc_sg_default"{

    vpc_id = aws_vpc.project02-eks-vpc.id

    ingress {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}



// Bastion SSH
resource "aws_security_group" "project02-bastion-sg" {
  vpc_id = aws_vpc.project02-eks-vpc.id
  name = "project02-bastion-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { //HTTP
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //HTTPS
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //ICMP
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project02-bastion-sg"
  }
}





// EKS Cluster SG
resource "aws_security_group" "project02-eks_sg_controlplane" {

    vpc_id = aws_vpc.project02-eks-vpc.id
    name = "project02-EKS-SG-ControlPlane"
    description = "Communication between the control plane and worker nodegroups"

    tags = {
      "Name" = "project02-EKS-ControlPlane-SG"
    }
}

resource "aws_security_group_rule" "project02-eks_sg_cluster_inbound" {

    security_group_id = aws_security_group.project02-eks_sg_controlplane.id
    source_security_group_id = aws_security_group.project02-eks_sg_nodes.id

    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow nodes to communicate with the cluster API Server"
}

resource "aws_security_group_rule" "project02-eks_sg_cluster_outbound" {

    security_group_id = aws_security_group.project02-eks_sg_controlplane.id
    source_security_group_id = aws_security_group.project02-eks_sg_nodes.id

    type = "egress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    description = "Allow Cluster API Server to communicate with the worker nodes"
}
// Bastion
resource "aws_security_group_rule" "project02-eks_sg_cluster_bastion" {
    security_group_id = aws_security_group.project02-eks_sg_controlplane.id
    source_security_group_id = aws_security_group.project02-bastion-sg.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow bastion nodes to communicate with the cluster API Server"   
}

// EKS Worker Node SG
resource "aws_security_group" "project02-eks_sg_nodes" {

    vpc_id = aws_vpc.project02-eks-vpc.id
    name = "project02-EKS-SG-NodeGroup"
    description = "Security group for worker nodes in Cluster"

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "project02-EKS-NodeGroup-SG"
      "kubernetes.io/cluster/project02-eks-cluster" = "owned",
    }
}

resource "aws_security_group_rule" "project02-eks_sg_nodes_internal" {

    security_group_id = aws_security_group.project02-eks_sg_nodes.id
    source_security_group_id = aws_security_group.project02-eks_sg_nodes.id

    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    description = "Allow nodes to communicate with each other"
}

resource "aws_security_group_rule" "project02-eks_sg_nodes_inbound" {

    security_group_id = aws_security_group.project02-eks_sg_nodes.id
    source_security_group_id = aws_security_group.project02-eks_sg_controlplane.id

    type = "ingress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"   
}

resource "aws_security_group_rule" "project02-eks_sg_nodes_ssh_inbound" {

    security_group_id = aws_security_group.project02-eks_sg_nodes.id
    source_security_group_id = aws_security_group.project02-eks_sg_controlplane.id

    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow ssh worker Kubelets and pods to receive communication from the cluster control plane"   
}