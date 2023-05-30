region        = "us-east-1"
ec2_type      = "t2.micro"
ami_id        = "ami-06e46074ae430fba6"
key_pair_name = "aws_keys_pairs"
cidr_block    = "10.0.0.0/16"
subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24",
  "10.0.4.0/24"
]
