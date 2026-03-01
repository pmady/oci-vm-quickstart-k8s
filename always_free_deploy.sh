#!/bin/bash
# OCI "Always Free" Infrastructure Deployment Script
# This script creates a VCN, Subnet, Security List,
# and an E2.1.Micro VM at no cost.
#
# Prerequisites:
#   - OCI CLI installed and configured (oci setup config)
#
# Usage:
#   ./always_free_deploy.sh

set -euo pipefail

# Set your Compartment OCID here
COMPARTMENT_ID="ocid1.tenancy.oc1..aaaaaaaagp7ohfqddxvalhaxmt47i4v2ihd52ypyq544pffijpza4vignvnq"

# Verify OCI CLI is configured
if ! command -v oci &> /dev/null; then
    echo "ERROR: OCI CLI is not installed. Install it from:"
    echo "  https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm"
    exit 1
fi

echo "=== OCI Always Free Infrastructure Deployment ==="
echo "Compartment: $COMPARTMENT_ID"
echo ""

# --- Step 1: Create VCN ---
echo "1. Creating Virtual Cloud Network (VCN)..."
VCN_ID=$(oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "10.0.0.0/16" \
    --display-name "ACE-Apprentice-VCN" \
    --dns-label "acevcn" \
    --query 'data.id' --raw-output)
echo "   VCN created: $VCN_ID"

# --- Step 2: Update Default Security List (allow SSH and HTTP/HTTPS ingress) ---
echo "2. Configuring security list (SSH, HTTP, HTTPS ingress)..."
SL_ID=$(oci network vcn get --vcn-id "$VCN_ID" --query 'data."default-security-list-id"' --raw-output)
oci network security-list update \
    --security-list-id "$SL_ID" \
    --ingress-security-rules '[
        {"source":"0.0.0.0/0","protocol":"6","tcpOptions":{"destinationPortRange":{"min":22,"max":22}}},
        {"source":"0.0.0.0/0","protocol":"6","tcpOptions":{"destinationPortRange":{"min":80,"max":80}}},
        {"source":"0.0.0.0/0","protocol":"6","tcpOptions":{"destinationPortRange":{"min":443,"max":443}}},
        {"source":"0.0.0.0/0","protocol":"6","tcpOptions":{"destinationPortRange":{"min":6443,"max":6443}}},
        {"source":"0.0.0.0/0","protocol":"1","icmpOptions":{"code":4,"type":3}},
        {"source":"10.0.0.0/16","protocol":"1","icmpOptions":{"type":3}}
    ]' \
    --egress-security-rules '[
        {"destination":"0.0.0.0/0","protocol":"all"}
    ]' \
    --force
echo "   Security list updated: $SL_ID"

# --- Step 3: Create Subnet ---
echo "3. Creating Subnet..."
SUBNET_ID=$(oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$VCN_ID" \
    --cidr-block "10.0.1.0/24" \
    --display-name "ACE-Subnet" \
    --dns-label "acesubnet" \
    --security-list-ids "[\"$SL_ID\"]" \
    --query 'data.id' --raw-output)
echo "   Subnet created: $SUBNET_ID"

# --- Step 4: Get Availability Domain ---
echo "4. Looking up availability domain..."
AD_NAME=$(oci iam availability-domain list \
    --compartment-id "$COMPARTMENT_ID" \
    --query 'data[0].name' --raw-output)
echo "   Availability Domain: $AD_NAME"

# --- Step 5: Get Latest Oracle Linux 9 Image compatible with E2.1.Micro ---
echo "5. Looking up latest Oracle Linux 9 image for E2.1.Micro..."
IMAGE_ID=$(oci compute image list \
    --compartment-id "$COMPARTMENT_ID" \
    --operating-system "Oracle Linux" \
    --operating-system-version "9" \
    --shape "VM.Standard.E2.1.Micro" \
    --sort-by TIMECREATED \
    --sort-order DESC \
    --limit 1 \
    --query 'data[0].id' --raw-output)

if [ -z "$IMAGE_ID" ] || [ "$IMAGE_ID" = "None" ] || [ "$IMAGE_ID" = "null" ]; then
    echo "   --shape filter returned no results, trying without filter..."
    # Fallback: get all OL9 images and pick one that isn't aarch64
    IMAGE_ID=$(oci compute image list \
        --compartment-id "$COMPARTMENT_ID" \
        --operating-system "Oracle Linux" \
        --operating-system-version "9" \
        --sort-by TIMECREATED \
        --sort-order DESC \
        --all \
        --output json | python3 -c "
import sys, json
data = json.load(sys.stdin).get('data', [])
for img in data:
    name = img.get('display-name', '')
    if 'aarch64' not in name.lower():
        print(img['id'])
        break
")
fi

if [ -z "$IMAGE_ID" ] || [ "$IMAGE_ID" = "None" ] || [ "$IMAGE_ID" = "null" ]; then
    echo "ERROR: Could not find a compatible Oracle Linux 9 image."
    exit 1
fi
echo "   Image: $IMAGE_ID"

# --- Step 6: Launch Always-Free Micro Instance ---
echo "6. Launching Always-Free Instance (VM.Standard.E2.1.Micro, 1 OCPU, 1GB RAM)..."
INSTANCE_ID=$(oci compute instance launch \
    --availability-domain "$AD_NAME" \
    --compartment-id "$COMPARTMENT_ID" \
    --shape "VM.Standard.E2.1.Micro" \
    --subnet-id "$SUBNET_ID" \
    --display-name "ACE-Free-VM" \
    --image-id "$IMAGE_ID" \
    --query 'data.id' --raw-output)
echo "   Instance launched: $INSTANCE_ID"

# --- Step 7: Wait for Instance and Get Private IP ---
echo "7. Waiting for instance to reach RUNNING state..."
oci compute instance get --instance-id "$INSTANCE_ID" --wait-for-state RUNNING --wait-interval-seconds 10 > /dev/null 2>&1 || true

PRIVATE_IP=$(oci compute instance list-vnics \
    --instance-id "$INSTANCE_ID" \
    --query 'data[0]."private-ip"' --raw-output)

echo ""
echo "=== Deployment Complete ==="
echo "Instance ID:  $INSTANCE_ID"
echo "Private IP:   $PRIVATE_IP"
