# Oracle ACE Apprentice - Product Usage Milestone Submission

## Submission 1: GitHub Code — OCI Infrastructure Automation

**Product:** Oracle Cloud Infrastructure (OCI) CLI  
**Repository:** https://github.com/pmady/oci-vm-quickstart-k8s

### Description

Created an automated deployment script for Oracle Cloud Infrastructure that provisions a complete Always Free environment using the OCI CLI. The script automates the creation of networking and compute resources within OCI's Always Free tier limits.

### What Was Created

A production-ready bash script (`always_free_deploy.sh`) that automates:

1. **Virtual Cloud Network (VCN)** — 10.0.0.0/16 CIDR with DNS enabled
2. **Security List Configuration** — Ingress rules for SSH (22), HTTP (80), HTTPS (443), Kubernetes API (6443), and ICMP
3. **Regional Subnet** — 10.0.1.0/24 subnet associated with the security list
4. **Availability Domain Lookup** — Dynamic discovery of the AD for the tenancy
5. **Compute Instance Launch** — VM.Standard.A1.Flex (ARM, 1 OCPU, 6GB RAM) with Oracle Linux 9.7
6. **Retry Logic** — Automatic retry every 60 seconds for capacity issues (common with Always Free A1.Flex)

### Technical Details

- **Language:** Bash with OCI CLI commands
- **Error Handling:** Uses `set -euo pipefail` for strict error handling
- **Idempotent Image Selection:** Hardcoded region-specific image OCID for reliability
- **Cost Protection:** All resources strictly within OCI Always Free tier (VM.Standard.A1.Flex: 1 OCPU, 6GB RAM; Boot Volume: 47GB default; VCN, Subnet, Security List: Always Free)

### OCI Services Demonstrated

- OCI CLI (`oci` command-line interface)
- OCI Compute (VM.Standard.A1.Flex shape)
- OCI Networking (VCN, Subnet, Security Lists)
- OCI IAM (Availability Domain listing)

### What I Learned

- OCI CLI syntax and JMESPath query filtering for resource management
- OCI Always Free tier resource limits and shape availability per region
- ARM (aarch64) vs x86_64 image compatibility with different compute shapes
- OCI networking architecture: VCN → Subnet → Security List relationships
- Handling "Out of host capacity" errors common with Always Free compute instances
- Best practices for automating OCI infrastructure provisioning

---

## Submission 2: Oracle Autonomous Database + APEX Application

**Product:** Oracle Autonomous Database, Oracle APEX  

### Description

Provisioned an Always Free Oracle Autonomous Database and built a web application using Oracle APEX (Application Express) — Oracle's low-code development platform built into every Autonomous Database.

### What Was Created

1. **Autonomous Database (ATP)**
   - Name: ACE-Demo-ADB
   - Workload: Transaction Processing
   - Deployment: Serverless (Always Free)
   - Storage: 20GB
   - Region: us-chicago-1

2. **APEX Web Application**
   - Application: OCI Resource Tracker
   - Features: Interactive reports, data entry forms, dashboard
   - Purpose: Track and manage OCI cloud resources

### OCI Services Demonstrated

- Oracle Autonomous Database (Transaction Processing)
- Oracle APEX (Application Express) — low-code web development
- OCI Console navigation and resource management

### What I Learned

- How to provision an Always Free Autonomous Database
- Oracle APEX workspace creation and application development
- Building interactive web applications without managing infrastructure
- Autonomous Database features: auto-scaling, auto-patching, auto-backup

### Screenshots

*(Add your screenshots below)*

1. Autonomous Database creation page
2. Autonomous Database AVAILABLE status
3. APEX workspace dashboard
4. APEX application builder
5. Running APEX application

---

## Submission 3: OCI Object Storage — Cloud Data Management

**Product:** Oracle Cloud Infrastructure Object Storage

### Description

Created an OCI Object Storage bucket to demonstrate cloud data storage and management capabilities within the Always Free tier (20GB free).

### What Was Created

1. **Object Storage Bucket**
   - Name: ace-demo-bucket
   - Storage Tier: Standard
   - Visibility: Private

2. **Uploaded Files**
   - Infrastructure automation scripts
   - Documentation and project artifacts

### OCI Services Demonstrated

- OCI Object Storage (bucket creation, object upload/download)
- OCI Console resource management
- Storage tier management (Standard, Infrequent Access, Archive)

### What I Learned

- OCI Object Storage namespace and bucket management
- Pre-authenticated requests for secure file sharing
- Storage tier options and lifecycle policies
- Integration with other OCI services

### Screenshots

*(Add your screenshots below)*

1. Object Storage bucket creation
2. Objects uploaded in bucket
3. Bucket details and settings
