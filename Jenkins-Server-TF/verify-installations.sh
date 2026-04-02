#!/bin/bash

echo "====== Checking Installed Tools ======"

check() {
  if command -v $1 &>/dev/null; then
    echo "[OK] $1 is installed: $($1 --version 2>/dev/null | head -n 1)"
  else
    echo "[MISSING] $1 is NOT installed!"
  fi
}

# JAVA
check java

# Jenkins service check
if systemctl is-active --quiet jenkins; then
  echo "[OK] Jenkins is running"
else
  echo "[MISSING] Jenkins not installed or not running"
fi

# Docker
check docker

# AWS CLI
check aws

# Kubectl
check kubectl

# Eksctl
check eksctl

# Terraform
check terraform

# Trivy
check trivy

# Helm
check helm

# SonarQube (via Docker container)
if docker ps --format '{{.Names}}' | grep -q "sonar"; then
  echo "[OK] SonarQube container is running"
else
  echo "[MISSING] SonarQube container NOT running"
fi

echo "====== Check Complete ======"

