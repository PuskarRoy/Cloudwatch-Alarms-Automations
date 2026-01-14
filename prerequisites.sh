#!/bin/bash
 
sudo apt update -y

sudo apt install -y software-properties-common

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install -y ansible python3 python3-boto3

curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

sudo dpkg -i session-manager-plugin.deb

sudo rm -fr amazon-ssm-agent.deb session-manager-plugin.deb

sudo snap install aws-cli --classic

set -e

OUT_FILE="./assets/inventory.aws_ec2.yml"

# extract the region value (supports quotes)
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
  "tag:Alarms-Automation": "Yes"
  instance-state-name: running

hostnames: instance-id

compose:
  ansible_connection: '"aws_ssm"'
  ansible_aws_ssm_bucket_name: '"$BUCKET_NAME"'
  ansible_aws_ssm_region: '"$REGION"'
EOF

echo "Generated $OUT_FILE"
echo "******************************************************"
echo "   $REGION_NAME $BUCKET_NAME                USE TAG : Alarms-Automation: Yes"
echo "******************************************************"
