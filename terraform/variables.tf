variable "project" {
  type    = string
  default = "iti_eks"
}
variable "region" {
  type        = string
  default     = "us-east-1"
  sensitive   = false
  description = "Infrastructure region"
}

variable "ec2_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for the infrastructure"
}

variable "ami_id" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "subnet_cidrs" {
  type = list(string)
}

