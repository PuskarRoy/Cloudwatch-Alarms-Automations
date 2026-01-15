#!/bin/bash
set -e

USERS=("admin1" "admin2")
if [[ -z "$BUCKET_NAME" ]]; then
  echo "Error: S3_BUCKET_NAME environment variable must be set"
  exit 1
fi

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

if [[ -z "$INSTANCE_ID" ]]; then
  echo "Error: Unable to fetch INSTANCE_ID from metadata"
  exit 1
fi

INSTANCE_NAME=$(/usr/local/bin/aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[].Instances[].Tags[?Key=='Name'].Value | [0]" \
  --output text)

if [[ -z "$INSTANCE_NAME" || "$INSTANCE_NAME" == "None" ]]; then
  echo "Error: Instance Name tag not found"
  exit 1
fi

sudo mkdir -p pvt_keys

for USERNAME in "${USERS[@]}"; do

  echo "Creating user: $USERNAME"

  sudo useradd -m -s /bin/bash "$USERNAME"

  sudo ssh-keygen -f "./pvt_keys/$USERNAME" -N ""

  sudo mkdir -p "/home/$USERNAME/.ssh"
  sudo mv "pvt_keys/$USERNAME.pub" "/home/$USERNAME/.ssh/authorized_keys"

  PEM_FILE="${INSTANCE_NAME}-${USERNAME}-KeyPair.pem"
  sudo mv "pvt_keys/$USERNAME" "$PEM_FILE"

  sudo chmod 700 "/home/$USERNAME/.ssh"
  sudo chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
  sudo chmod 600 "$PEM_FILE"
  sudo chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"

  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

  /usr/local/bin/aws s3 cp "$PEM_FILE" "s3://$BUCKET_NAME/Ssh-Private-Key/$PEM_FILE"

done

sudo rm -rf pvt_keys

echo "admin1 and admin2 users created successfully."
echo "PEM files uploaded to S3 bucket: $BUCKET_NAME"
