resource "aws_eks_node_group" "eks_nodes_gp" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids = [module.mynetwork.private_subnet01_id,
    module.mynetwork.private_subnet02_id,
  module.mynetwork.private_subnet03_id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  disk_size      = 20
  instance_types = ["t3.medium"]

  tags = {
    name = "eks_nodes_group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}


# EKS Node IAM Role
resource "aws_iam_role" "node" {
  name = "${var.project}-Worker-Role"

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

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}
