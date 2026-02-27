#!/bin/bash
# OCI "Always Free" Infrastructure Deployment Script
# This script creates a VCN, Subnet, and an ARM-based VM at no cost.

# Set your Compartment OCID here
COMPARTMENT_ID="pavanmadduri27"

echo "1. Creating Virtual Cloud Network (VCN)..."
VCN_ID=$(oci network vcn create --compartment-id $COMPARTMENT_ID --cidr-block "10.0.0.0/16" --display-name "ACE-Apprentice-VCN" --query 'data.id' --raw-output)

echo "2. Creating Internet Gateway..."
IG_ID=$(oci network internet-gateway create --compartment-id $COMPARTMENT_ID --is-enabled true --vcn-id $VCN_ID --display-name "ACE-Gateway" --query 'data.id' --raw-output)

echo "3. Creating Public Subnet..."
# Using 10.0.1.0/24 for the regional public subnet
SUBNET_ID=$(oci network subnet create --compartment-id $COMPARTMENT_ID --vcn-id $VCN_ID --cidr-block "10.0.1.0/24" --display-name "ACE-Public-Subnet" --query 'data.id' --raw-output)

echo "4. Launching Always-Free ARM Instance..."
# Shape: VM.Standard.A1.Flex is Always Free (1 OCPU, 6GB RAM)
oci compute instance launch \
    --availability-domain $(oci iam availability-domain list --compartment-id $COMPARTMENT_ID --query 'data[0].name' --raw-output) \
    --compartment-id $COMPARTMENT_ID \
    --shape "VM.Standard.A1.Flex" \
    --shape-config '{"ocpus":1,"memoryInGBs":6}' \
    --subnet-id $SUBNET_ID \
    --assign-public-ip true \
    --display-name "ACE-Free-VM" \
    --image-id ocid1.image.oc1.iad.aaaaaaaav5... # Replace with latest Oracle Linux Image OCID for your region
