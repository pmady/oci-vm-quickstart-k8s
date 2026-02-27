# OCI Automated Networking & Compute Deployment
This repository contains a bash script to provision a complete, **Always Free** environment on Oracle Cloud Infrastructure.

### Resources Created:
- **VCN:** 10.0.0.0/16 Virtual Cloud Network.
- **Internet Gateway:** Provides external connectivity for the public subnet.
- **Regional Subnet:** A public subnet for hosting web-facing resources.
- **Compute Instance:** An ARM-based **Ampere A1** instance (1 OCPU, 6GB RAM).

### Cost Protection:
The script strictly uses the `VM.Standard.A1.Flex` shape and regional networking components that fall within the OCI Always Free tier limits, ensuring no usage charges are incurred.
