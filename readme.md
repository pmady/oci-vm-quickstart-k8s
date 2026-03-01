# OCI Automated Networking & Compute Deployment

This repository contains a bash script to provision a complete, **Always Free** environment on Oracle Cloud Infrastructure.

## Prerequisites

- **OCI CLI** installed and configured (`oci setup config`)
- **SSH key pair** (default: `~/.ssh/id_rsa.pub`)
- **Compartment OCID** (your tenancy or compartment OCID)

## Usage

```bash
chmod +x always_free_deploy.sh
./always_free_deploy.sh <COMPARTMENT_OCID> [SSH_PUBLIC_KEY_PATH]
```

**Example:**
```bash
./always_free_deploy.sh ocid1.tenancy.oc1..aaaaaaa... ~/.ssh/id_rsa.pub
```

## Resources Created

- **VCN:** 10.0.0.0/16 Virtual Cloud Network with DNS
- **Security List:** Ingress rules for SSH (22), HTTP (80), HTTPS (443), K8s API (6443)
- **Subnet:** 10.0.1.0/24 subnet for hosting resources
- **Compute Instance:** An **E2.1.Micro** instance (1 OCPU, 1GB RAM)

## Cost Protection

The script strictly uses the `VM.Standard.E2.1.Micro` shape and regional networking components that fall within the OCI Always Free tier limits, ensuring no usage charges are incurred.

## Connect to Your Instance

After deployment completes, SSH into the instance:
```bash
ssh opc@<PUBLIC_IP>
```
