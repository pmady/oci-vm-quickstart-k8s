#!/bin/bash
# OCI Always Free - Autonomous Database + APEX Deployment Script
#
# Creates an Always Free Oracle Autonomous Transaction Processing (ATP)
# database with Oracle APEX enabled. APEX is built into every Autonomous
# Database and provides a low-code web application development platform.
#
# Always Free Resources Used:
#   - Autonomous Database: 1 OCPU, 20GB storage (free up to 2 instances)
#   - Oracle APEX: Built-in, no extra cost
#
# Prerequisites:
#   - OCI CLI installed and configured (oci setup config)
#
# Usage:
#   ./deploy_autonomous_db.sh

set -euo pipefail

COMPARTMENT_ID="ocid1.tenancy.oc1..aaaaaaaagp7ohfqddxvalhaxmt47i4v2ihd52ypyq544pffijpza4vignvnq"
DB_NAME="ACEDEMODB"
DISPLAY_NAME="ACE-Demo-Autonomous-DB"
DB_WORKLOAD="OLTP"
# Password must be 12-30 chars, 1 upper, 1 lower, 1 number, no double quotes
ADMIN_PASSWORD="WelcomeACE2026#"

if ! command -v oci &> /dev/null; then
    echo "ERROR: OCI CLI is not installed."
    exit 1
fi

echo "=============================================="
echo " OCI Always Free - Autonomous Database Setup"
echo "=============================================="
echo "Compartment: $COMPARTMENT_ID"
echo "DB Name:     $DB_NAME"
echo "Workload:    $DB_WORKLOAD (Transaction Processing)"
echo ""

# --- Step 1: Create Always Free Autonomous Database ---
echo "1. Creating Always Free Autonomous Database..."
echo "   This takes 2-5 minutes to provision..."

ADB_ID=$(oci db autonomous-database create \
    --compartment-id "$COMPARTMENT_ID" \
    --db-name "$DB_NAME" \
    --display-name "$DISPLAY_NAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --cpu-core-count 1 \
    --data-storage-size-in-tbs 1 \
    --db-workload "$DB_WORKLOAD" \
    --is-free-tier true \
    --is-auto-scaling-enabled false \
    --query 'data.id' --raw-output)

echo "   Autonomous DB created: $ADB_ID"

# --- Step 2: Wait for Database to become AVAILABLE ---
echo "2. Waiting for database to reach AVAILABLE state..."
oci db autonomous-database get \
    --autonomous-database-id "$ADB_ID" \
    --wait-for-state AVAILABLE \
    --wait-interval-seconds 15 > /dev/null 2>&1 || true

# --- Step 3: Get Database Details ---
echo "3. Retrieving database connection details..."

DB_INFO=$(oci db autonomous-database get \
    --autonomous-database-id "$ADB_ID" \
    --query 'data.{"state":"lifecycle-state","apex_url":"connection-urls"."apex-url","sql_dev_url":"connection-urls"."sql-dev-web-url","db_version":"db-version","cpu":"cpu-core-count","storage_tb":"data-storage-size-in-tbs","display_name":"display-name"}')

STATE=$(echo "$DB_INFO" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['state'])" 2>/dev/null || echo "UNKNOWN")
APEX_URL=$(echo "$DB_INFO" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['apex_url'])" 2>/dev/null || echo "N/A")
SQL_URL=$(echo "$DB_INFO" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['sql_dev_url'])" 2>/dev/null || echo "N/A")
DB_VERSION=$(echo "$DB_INFO" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['db_version'])" 2>/dev/null || echo "N/A")

echo ""
echo "=============================================="
echo " Autonomous Database Deployment Complete!"
echo "=============================================="
echo ""
echo "Database Details:"
echo "  DB Name:      $DB_NAME"
echo "  Display Name: $DISPLAY_NAME"
echo "  DB ID:        $ADB_ID"
echo "  State:        $STATE"
echo "  DB Version:   $DB_VERSION"
echo "  Workload:     Transaction Processing (OLTP)"
echo "  CPU:          1 OCPU (Always Free)"
echo "  Storage:      1 TB (Always Free)"
echo ""
echo "Access URLs:"
echo "  APEX URL:         $APEX_URL"
echo "  SQL Developer:    $SQL_URL"
echo ""
echo "Credentials:"
echo "  Admin Username:   ADMIN"
echo "  Admin Password:   (as configured in script)"
echo ""
echo "=============================================="
echo " Next Steps:"
echo "=============================================="
echo "1. Open the APEX URL above in your browser"
echo "2. Sign in with: ADMIN / $ADMIN_PASSWORD"
echo "3. Create a new APEX Workspace"
echo "4. Build your first APEX application!"
echo ""
echo "Cost: \$0 (Always Free Tier)"
echo "=============================================="
