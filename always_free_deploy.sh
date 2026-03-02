#!/bin/bash
# OCI "Always Free" Infrastructure Deployment Script
# Creates a VCN, Subnet, Security List, and an Always Free VM instance.
#
# The script tries ALL availability domains to maximize the chance of
# finding capacity for Always Free ARM (A1.Flex) instances.
#
# Always Free Resources Used:
#   - VM.Standard.A1.Flex: 1 OCPU, 6GB RAM (free up to 4 OCPUs, 24GB)
#   - Boot Volume: 47GB default (free up to 200GB total)
#   - VCN, Subnet, Security List: Always Free
#
# Prerequisites:
#   - OCI CLI installed and configured (oci setup config)
#
# Usage:
#   ./always_free_deploy.sh

set -euo pipefail

COMPARTMENT_ID="ocid1.tenancy.oc1..aaaaaaaagp7ohfqddxvalhaxmt47i4v2ihd52ypyq544pffijpza4vignvnq"
SHAPE="VM.Standard.A1.Flex"
SHAPE_CONFIG='{"ocpus":1,"memoryInGBs":6}'
# Oracle-Linux-9.7-aarch64-2026.01.29-0 (us-chicago-1)
IMAGE_ID="ocid1.image.oc1.us-chicago-1.aaaaaaaa2zhuh4picmv5uqn4zlcgyzz7z2beuvxsizo5ggntovq65jxzxeua"

if ! command -v oci &> /dev/null; then
    echo "ERROR: OCI CLI is not installed."
    exit 1
fi

echo "=== OCI Always Free Infrastructure Deployment ==="
echo "Region:      us-chicago-1"
echo "Compartment: $COMPARTMENT_ID"
echo "Shape:       $SHAPE"
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

# --- Step 2: Update Default Security List ---
echo "2. Configuring security list (SSH, HTTP, HTTPS, K8s API)..."
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
    --force > /dev/null
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
echo "   Waiting for subnet to become available..."
sleep 10
echo "   Subnet ready."

# --- Step 4: Get ALL Availability Domains ---
echo "4. Looking up all availability domains..."
readarray -t AD_LIST < <(oci iam availability-domain list \
    --compartment-id "$COMPARTMENT_ID" \
    --query 'data[*].name' --raw-output | tr -d '[]"' | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -v '^$')
echo "   Found ${#AD_LIST[@]} availability domain(s): ${AD_LIST[*]}"

# --- Step 5: Launch Instance (try all ADs with retry) ---
echo "5. Launching Always-Free Instance ($SHAPE, 1 OCPU, 6GB RAM)..."
echo "   Will try all availability domains. Retries every 30s for up to 30 min."

MAX_ROUNDS=60
INSTANCE_ID=""

for ((ROUND=1; ROUND<=MAX_ROUNDS; ROUND++)); do
    for AD_NAME in "${AD_LIST[@]}"; do
        echo "   [Round $ROUND] Trying AD: $AD_NAME ..."
        LAUNCH_OUTPUT=$(oci compute instance launch \
            --availability-domain "$AD_NAME" \
            --compartment-id "$COMPARTMENT_ID" \
            --shape "$SHAPE" \
            --shape-config "$SHAPE_CONFIG" \
            --subnet-id "$SUBNET_ID" \
            --display-name "ACE-Free-VM" \
            --image-id "$IMAGE_ID" \
            --query 'data.id' --raw-output 2>&1) || true

        if [[ "$LAUNCH_OUTPUT" == ocid1.instance.* ]]; then
            INSTANCE_ID="$LAUNCH_OUTPUT"
            echo "   SUCCESS! Instance launched in $AD_NAME"
            echo "   Instance ID: $INSTANCE_ID"
            break 2
        elif echo "$LAUNCH_OUTPUT" | grep -q "Out of host capacity"; then
            echo "   -> Out of host capacity in $AD_NAME"
        else
            echo "   -> Error: $LAUNCH_OUTPUT"
        fi
    done

    if [ -z "$INSTANCE_ID" ]; then
        echo "   All ADs exhausted. Waiting 30s before next round..."
        sleep 30
    fi
done

if [ -z "$INSTANCE_ID" ]; then
    echo ""
    echo "ERROR: Could not find capacity after $MAX_ROUNDS rounds."
    echo "TIP:   A1.Flex capacity in us-chicago-1 is limited."
    echo "       Try again during off-peak hours (early morning US time)."
    exit 1
fi

# --- Step 6: Wait for Instance and Get IP ---
echo "6. Waiting for instance to reach RUNNING state..."
oci compute instance get --instance-id "$INSTANCE_ID" \
    --wait-for-state RUNNING --wait-interval-seconds 10 > /dev/null 2>&1 || true

PRIVATE_IP=$(oci compute instance list-vnics \
    --instance-id "$INSTANCE_ID" \
    --query 'data[0]."private-ip"' --raw-output)

echo ""
echo "=== Deployment Complete ==="
echo "Instance ID:  $INSTANCE_ID"
echo "Private IP:   $PRIVATE_IP"
echo "Shape:        $SHAPE (Always Free)"
echo "Image:        Oracle Linux 9.7 (aarch64)"
