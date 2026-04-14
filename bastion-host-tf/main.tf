locals {
  org        = "To-Do-App"
  env        = "dev"
  aws-region = "us-east-1"
}






resource "aws_instance" "jump_server" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = "m7i-flex.large"
  key_name               = "login_ec2"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = data.aws_subnets.public.ids[0]
  iam_instance_profile   = "ec2-instance-profile"
  user_data              = <<-EOF
              #!/bin/bash
              # Update system
              sudo apt update -y


              # Install AWS CLI
              sudo apt install unzip
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
