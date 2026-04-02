
terraform {
    backend "s3" {
    bucket       = "mern-stack-end-to-end-three-tier-devsecops-project"
    region       = "us-east-1"
    key          = "Jenkins-Server.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}
