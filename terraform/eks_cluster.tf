resource "aws_eks_cluster" "eks_cluster" {
  name = "eks_CLUSTER"

  role_arn                  = aws_iam_role.clusterRole.arn
  enabled_cluster_log_types = ["api", "authenticator"]

  vpc_config {
    subnet_ids = [module.mynetwork.private_subnet01_id,
      module.mynetwork.private_subnet02_id,
    module.mynetwork.private_subnet03_id]
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]

  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# EKS Cluster IAM Role
resource "aws_iam_role" "clusterRole" {
  name = "${var.project}-Cluster-Role"

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


resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.clusterRole.name
}

resource "aws_security_group" "eks_cluster_sg" {
  name   = "eks-cluster-sg"
  vpc_id = module.mynetwork.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [module.mynetwork.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


