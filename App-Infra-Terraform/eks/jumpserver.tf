

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get all public subnets in the VPC
data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${local.org}-public*"]   
  }
}

# Get all private subnets in the VPC
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${local.org}-private*"]  
  }
}

data "aws_security_group" "eks-cluster-sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${local.org}-eks-cluster-sg"]   
  }
}




resource "aws_instance" "jump_server" {
  ami                    = data.aws_ami.ami
  instance_type          = "t3.micro"
  region                 = var.aws-region
  subnet_id              = data.aws_subnets.public.ids[0] 
  vpc_security_group_ids = data.aws_security_group.eks-cluster-sg.id
  iam_instance_profile   = "ec2-instance-profile"   
  depends_on             = [module.eks] # ensures EKS module completes first
  user_data = <<-EOF
              #!/bin/bash
              # Update system
              sudo yum update -y

              # Install AWS CLI
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x kubectl
              sudo mv kubectl /usr/local/bin/

              # Install eksctl
              curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
              sudo mv /tmp/eksctl /usr/local/bin/

              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

              EOF


  tags = {
    Name = "${local.env}-${local.org}-jumpserver"
  }
}
