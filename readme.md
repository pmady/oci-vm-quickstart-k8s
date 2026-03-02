# OCI Always Free - Networking + Compute VM

Automated deployment of a complete VCN, security list, subnet, and ARM-based compute instance on Oracle Cloud Infrastructure. **100% Always Free tier — zero cost.**

## Prerequisites

- **OCI CLI** installed and configured (`oci setup config`)
- Or use **OCI Cloud Shell** (pre-configured, no setup needed)

## Usage

```bash
git clone https://github.com/pmady/oci-vm-quickstart-k8s.git
cd oci-vm-quickstart-k8s
chmod +x always_free_deploy.sh
./always_free_deploy.sh
```

## What the Script Does

1. **Creates** a VCN (10.0.0.0/16) with DNS
2. **Configures** security list with SSH, HTTP, HTTPS, and K8s API ingress rules
3. **Creates** a regional subnet (10.0.1.0/24)
4. **Discovers** all availability domains in the region
5. **Launches** an ARM-based A1.Flex instance, trying all ADs for capacity
6. **Outputs** instance ID and private IP

## Resources Created

| Resource | Details | Cost |
|----------|---------|------|
| **VCN** | 10.0.0.0/16 with DNS | Free |
| **Security List** | SSH (22), HTTP (80), HTTPS (443), K8s API (6443) | Free |
| **Subnet** | 10.0.1.0/24 regional | Free |
| **Compute** | VM.Standard.A1.Flex (ARM, 1 OCPU, 6GB RAM) | Free |
| **Boot Volume** | 47GB default | Free |

> **Note:** A1.Flex capacity may be limited in some regions. The script automatically retries across all availability domains until a host is available.

## OCI Services Demonstrated

- **OCI Compute** — ARM-based Ampere A1 Flex virtual machines
- **OCI Networking** — VCN, Subnets, Security Lists
- **OCI IAM** — Availability domain discovery
- **OCI CLI** — Command-line infrastructure automation

## Related

- [oci-autonomous-db-apex](https://github.com/pmady/oci-autonomous-db-apex) — Autonomous Database + Oracle APEX deployment (also Always Free)
