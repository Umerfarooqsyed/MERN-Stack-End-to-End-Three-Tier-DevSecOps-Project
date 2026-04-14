#!/usr/bin/env bash
set -euo pipefail

AWS_ACCOUNT_ID="660573993595"
CLUSTER_NAME="dev-To-Do-App-eks-cluster"

# ── Step 1: Update kubeconfig ─────────────────────────────────────────────────
echo "Updating kubeconfig for cluster: $CLUSTER_NAME..."
aws eks update-kubeconfig \
  --name "$CLUSTER_NAME" \
  --region us-east-1
echo "kubeconfig updated."

# ── Step 2: Download IAM policy ───────────────────────────────────────────────
echo "Downloading IAM policy document..."
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
echo "IAM policy document downloaded."

# ── Step 3: Create IAM policy ─────────────────────────────────────────────────
echo "Creating IAM policy..."
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
echo "IAM policy created."

# ── Step 4: Create IAM service account ───────────────────────────────────────
echo "Creating IAM service account..."
eksctl create iamserviceaccount \
  --cluster="$CLUSTER_NAME" \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy" \
  --approve \
  --region=us-east-1
echo "IAM service account created."

# ── Step 5: Install Helm ──────────────────────────────────────────────────────
echo "Installing Helm..."
sudo snap install helm --classic
echo "Helm installed."

# ── Step 6: Add Helm repo and install Load Balancer Controller ────────────────
echo "Adding EKS Helm repo..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
echo "Helm repo added."

echo "Installing AWS Load Balancer Controller..."
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
echo "AWS Load Balancer Controller installed successfully."



___________________________________________
do this , apply if else condition or whatever suitable here 


kubectl get deployment -n kube-system aws-load-balancer-controller


if deployment is up and running then good , otherwise apply this command

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=dev-To-Do-App-eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-west-1 --set vpcId=vpc-0275df5b4b0eb8f55 -n kube-system

  __________________________________________-

  kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

____________-_____________________________________-
  