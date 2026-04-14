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
    values = ["${local.env}-${local.org}-subnet-public*"]
  }
}

# Get all private subnets in the VPC
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${local.env}-${local.org}-subnet-private*"]
  }
}

# data "aws_security_group" "eks-cluster-sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.env}-${local.org}-eks-cluster-sg"]
#   }
# }


data "aws_vpc" "find_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.env}-${local.org}-vpc"]
  }

}

