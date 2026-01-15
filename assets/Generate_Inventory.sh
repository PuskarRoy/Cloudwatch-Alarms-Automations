#!/bin/bash

set -euo pipefail

OUT_FILE="./assets/inventory.aws_ec2.yml"

REGION=$REGION_NAME

if [ -z "$REGION" ]; then
  echo "Could not parse region from Environment." >&2
  exit 3
fi

BUCKET_NAME=$BUCKET_NAME

if [ -z "$BUCKET_NAME" ]; then
  echo "Could not parse bucket_name from Environment. " >&2
  exit 4
fi

cat > "$OUT_FILE" <<EOF
---
plugin: amazon.aws.aws_ec2

regions: $REGION

filters:
  "tag:Ansible-Automation": "Yes"
  instance-state-name: running

hostnames: instance-id

compose:
  ansible_connection: '"aws_ssm"'
  ansible_aws_ssm_bucket_name: '"$BUCKET_NAME"'
  ansible_aws_ssm_region: '"$REGION"'
EOF
