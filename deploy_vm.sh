#!/bin/bash
# OCI VM Deployment Script for ACE Apprentice Milestone
# Usage: ./deploy_vm.sh <compartment_id> <subnet_id>

COMPARTMENT_ID=$1
SUBNET_ID=$2

echo "Launching Oracle Linux 8 VM..."

oci compute instance launch \
    --availability-domain "Uocm:US-ASHBURN-AD-1" \
    --compartment-id $COMPARTMENT_ID \
    --shape "VM.Standard.E4.Flex" \
    --shape-config '{"ocpus":1,"memoryInGBs":16}' \
    --subnet-id $SUBNET_ID \
    --assign-public-ip true \
    --display-name "ACE-Apprentice-VM" \
    --image-id ocid1.image.oc1.iad.aaaaaaaav5... # Replace with latest Oracle Linux OCID
