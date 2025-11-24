#!/bin/bash

# Get IMDSv2 token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Get instance ID
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

# Get root device name from instance metadata
ROOT_DEVICE=$(lsblk -fro NAME,FSTYPE,MOUNTPOINT | grep " /$" | awk '{print $1}')

# Get Image ID using AWS CLI
IMAGE_ID=$(/usr/local/bin/aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[].Instances[].ImageId' --output text)

# Get filesystem type of root device
FSTYPE=$(lsblk -fro NAME,FSTYPE,MOUNTPOINT | grep " /$" | awk '{print $2}')

# Get Instance Name tag
INSTANCE_NAME=$(/usr/local/bin/aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query "Reservations[].Instances[].Tags[?Key=='Name'].Value | [0]" \
  --output text)

OUTPUT_FILE="$HOME/data_${INSTANCE_ID}.txt"

{
# Output results
echo "name: $INSTANCE_NAME"
echo "instance: $INSTANCE_ID"
echo "device: $ROOT_DEVICE"
echo "fstype: $FSTYPE"
echo "imageid: $IMAGE_ID"
} >  "$OUTPUT_FILE"
