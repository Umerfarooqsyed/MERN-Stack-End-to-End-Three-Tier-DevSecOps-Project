#!/bin/bash

echo "===================="
echo "Verifying Installations"
echo "===================="

# AWS CLI
if command -v aws &> /dev/null; then
    aws_ver=$(aws --version 2>&1)
    echo "✅ AWS CLI installed: $aws_ver"
else
    echo "❌ AWS CLI NOT installed"
fi

# kubectl
if command -v kubectl &> /dev/null; then
    kubectl_ver=$(kubectl version --client -o json 2>/dev/null | jq -r '.clientVersion.gitVersion' 2>/dev/null)
    if [ -z "$kubectl_ver" ]; then
        # fallback if jq not installed
        kubectl_ver=$(kubectl version --client --short 2>/dev/null | awk '{print $3}')
    fi
    echo "✅ kubectl installed: $kubectl_ver"
else
    echo "❌ kubectl NOT installed"
fi

# eksctl
if command -v eksctl &> /dev/null; then
    eksctl_ver=$(eksctl version 2>/dev/null)
    echo "✅ eksctl installed: $eksctl_ver"
else
    echo "❌ eksctl NOT installed"
fi

# Helm
if command -v helm &> /dev/null; then
    helm_ver=$(helm version --short 2>/dev/null)
    echo "✅ Helm installed: $helm_ver"
else
    echo "❌ Helm NOT installed"
fi

echo "===================="
echo "Verification Complete"
echo "===================="
