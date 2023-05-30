data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public_subnet01" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    # "KubernetesCluster"                 = "EKS_Cluster"
    "Name" = "public-subnet01"
    # "kubernetes.io/cluster/EKS_Cluster" = "shared"
    # "kubernetes.io/role/elb"            = 1
  }
}


resource "aws_subnet" "private_subnet01" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    # "KubernetesCluster"                 = "EKS_Cluster"
    "Name" = "private-subnet01"
    # "kubernetes.io/cluster/EKS_Cluster" = "shared"
    # "kubernetes.io/role/internal-elb"   = 1
  }
}

resource "aws_subnet" "private_subnet02" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[2]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    # "KubernetesCluster"                 = "EKS_Cluster"
    "Name" = "private-subnet02"
    # "kubernetes.io/cluster/EKS_Cluster" = "shared"
    # "kubernetes.io/role/internal-elb"   = 1
  }
}

resource "aws_subnet" "private_subnet03" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[3]
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    # "KubernetesCluster"                 = "EKS_Cluster"
    "Name" = "private-subnet03"
    # "kubernetes.io/cluster/EKS_Cluster" = "shared"
    # "kubernetes.io/role/internal-elb"   = 1
  }

}
