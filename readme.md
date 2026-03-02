# OCI Always Free Infrastructure Automation

Automated deployment scripts for Oracle Cloud Infrastructure using **only Always Free tier resources**. Zero cost, fully automated via OCI CLI.

## Prerequisites

- **OCI CLI** installed and configured (`oci setup config`)
- OCI Cloud Shell (pre-configured) or local machine with OCI CLI

## Scripts

### 1. Autonomous Database + APEX (`deploy_autonomous_db.sh`)

Provisions an Always Free Oracle Autonomous Transaction Processing (ATP) database with Oracle APEX — a low-code web application development platform.

```bash
chmod +x deploy_autonomous_db.sh
./deploy_autonomous_db.sh
```

**Resources Created:**
- **Autonomous Database:** 1 OCPU, 20GB storage, Transaction Processing (OLTP)
- **Oracle APEX:** Built-in low-code app development platform (auto-enabled)

**Output:** Database ID, APEX URL, SQL Developer Web URL, admin credentials

### 2. Networking + Compute VM (`always_free_deploy.sh`)

Provisions a complete VCN with security rules and an ARM-based compute instance.

```bash
chmod +x always_free_deploy.sh
./always_free_deploy.sh
```

**Resources Created:**
- **VCN:** 10.0.0.0/16 Virtual Cloud Network with DNS
- **Security List:** Ingress rules for SSH (22), HTTP (80), HTTPS (443), K8s API (6443)
- **Subnet:** 10.0.1.0/24 regional subnet
- **Compute Instance:** VM.Standard.A1.Flex (ARM, 1 OCPU, 6GB RAM)

> **Note:** A1.Flex capacity may be limited in some regions. The script automatically retries across all availability domains until a host is available.

## Always Free Tier Resources Used

| Resource | Script | Free Tier Limit |
|----------|--------|-----------------|
| Autonomous Database | `deploy_autonomous_db.sh` | 2 instances (1 OCPU, 20GB each) |
| Oracle APEX | `deploy_autonomous_db.sh` | Built-in, unlimited |
| Compute (A1.Flex) | `always_free_deploy.sh` | 4 OCPUs, 24GB RAM total |
| Boot Volume | `always_free_deploy.sh` | 200GB total |
| VCN | `always_free_deploy.sh` | 2 VCNs |
| Subnet | `always_free_deploy.sh` | 2 subnets |

## Cost

**$0** — All resources are within Oracle Cloud Always Free tier limits.

## OCI Services Demonstrated

- **Oracle Autonomous Database** — Fully managed database with auto-patching, auto-backup
- **Oracle APEX** — Low-code application development platform
- **OCI Compute** — ARM-based Ampere A1 Flex virtual machines
- **OCI Networking** — VCN, Subnets, Security Lists
- **OCI CLI** — Command-line automation of cloud infrastructure
