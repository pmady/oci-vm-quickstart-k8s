# OCI Automated Networking & Compute Deployment

This repository contains a bash script to provision a complete, **Always Free** environment on Oracle Cloud Infrastructure.

## Prerequisites

- **OCI CLI** installed and configured (`oci setup config`)

## Usage

```bash
chmod +x always_free_deploy.sh
./always_free_deploy.sh
```

## Resources Created

- **VCN:** 10.0.0.0/16 Virtual Cloud Network with DNS
- **Security List:** Ingress rules for SSH (22), HTTP (80), HTTPS (443), K8s API (6443)
- **Subnet:** 10.0.1.0/24 subnet for hosting resources
- **Compute Instance:** An **E2.1.Micro** instance (1 OCPU, 1GB RAM)

## Cost Protection

The script strictly uses the `VM.Standard.E2.1.Micro` shape and regional networking components that fall within the OCI Always Free tier limits, ensuring no usage charges are incurred.

## After Deployment

The script will output the instance ID and private IP once the VM is running.
