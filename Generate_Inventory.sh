#!/usr/bin/env bash
set -euo pipefail

VARS_FILE="${1:-alarm_config.yml}"
OUT_FILE="${2:-inventory.aws_ec2.yml}"

if [ ! -f "$VARS_FILE" ]; then
  echo "vars file not found: $VARS_FILE" >&2
  exit 2
fi

# extract the region value (supports quotes)
REGION=$(grep -E '^[[:space:]]*region[[:space:]]*:' "$VARS_FILE" | head -n1 | sed -E 's/^[^:]*:[[:space:]]*["'\'']?([^"'\'' ]+)["'\'']?.*$/\1/')

if [ -z "$REGION" ]; then
  echo "Could not parse region from $VARS_FILE. Ensure it contains a line like: region: ap-south-1" >&2
  exit 3
fi

BUCKET_NAME=$(grep -E '^[[:space:]]*bucket_name[[:space:]]*:' "$VARS_FILE" | head -n1 | sed -E 's/^[^:]*:[[:space:]]*["'\'']?([^"'\'' ]+)["'\'']?.*$/\1/')

if [ -z "$BUCKET_NAME" ]; then
  echo "Could not parse bucket_name from $VARS_FILE. Ensure it contains a line like: bucket_name: ansible-automation-test123" >&2
  exit 4
fi

cat > "$OUT_FILE" <<EOF
---
plugin: amazon.aws.aws_ec2

regions: $REGION

filters:
  "tag:Alarms-Automations": "Yes"
  instance-state-name: running

hostnames: instance-id

compose:
  ansible_connection: '"aws_ssm"'
  ansible_aws_ssm_bucket_name: '"$BUCKET_NAME"'
  ansible_aws_ssm_region: '"$REGION"'
EOF

echo "Generated $OUT_FILE with region=$REGION"
