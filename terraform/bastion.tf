resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key : Write the custom name of your key
  key_name = "aws_keys_pairs"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
    EOT
  }
}


# locals {
#   private_key_base64 = base64encode(tls_private_key.terrafrom_generated_private_key.private_key_pem)
# }


resource "aws_instance" "bastion_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_type
  security_groups             = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  subnet_id                   = module.mynetwork.public_subnet01_id

  tags = {
    Name = "Bastion Instance"
  }

  key_name = var.key_pair_name

  depends_on = [
    aws_key_pair.generated_key
  ]


  user_data = <<-EOF
              #!/bin/bash
                curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.4/2023-05-11/bin/linux/amd64/kubectl
                chmod +x ./kubectl
                mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
                sudo yum install pip
                pip install openshift
              EOF
}

resource "null_resource" "local_prov" {
  depends_on = [
    aws_instance.bastion_ec2
  ]

  provisioner "local-exec" {
    command = <<-EOT
    echo "${aws_instance.bastion_ec2.public_ip}" > inventory
    EOT
  }

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.mynetwork.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
