#!/bin/bash

# Define temporary working directory
TEMP_DIR="/tmp/cloudwatch-agent-temp"
CONFIG_FILE="/opt/aws/amazon-cloudwatch-agent/bin/config.json"

echo "=================================================="
echo " Installing Amazon CloudWatch Agent on EC2 Instance "
echo "=================================================="

# Step 1: Prepare temporary folder
echo "Creating temporary working directory at $TEMP_DIR ..."
mkdir -p "$TEMP_DIR"

# Step 2: Download the CloudWatch Agent
echo "Downloading the Amazon CloudWatch Agent..."
wget -O "$TEMP_DIR/AmazonCloudWatchAgent.zip" https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip

# Step 3: Unzip the CloudWatch Agent
echo "Unzipping the Amazon CloudWatch Agent..."
unzip -q "$TEMP_DIR/AmazonCloudWatchAgent.zip" -d "$TEMP_DIR"

# Step 4: Install the CloudWatch Agent
echo "Installing the Amazon CloudWatch Agent..."
cd "$TEMP_DIR" || exit 1
sudo ./install.sh
cd - >/dev/null || exit 1

# Step 5: Create the CloudWatch Agent configuration file
echo "Creating the CloudWatch Agent configuration file..."
sudo mkdir -p "$(dirname "$CONFIG_FILE")"
sudo bash -c "cat > $CONFIG_FILE" <<'EOT'
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "cwagent"
    },
    "metrics": {
        "append_dimensions": {
            "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
            "ImageId": "${aws:ImageId}",
            "InstanceId": "${aws:InstanceId}"
        },
        "metrics_collected": {
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "/"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60
            }
        }
    }
}
EOT

# Step 6: Apply the configuration and start the CloudWatch Agent
echo "Applying the configuration and starting the CloudWatch Agent..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -c "file:$CONFIG_FILE" -s

# Step 7: Start the CloudWatch Agent service
echo "Starting the CloudWatch Agent service..."
sudo service amazon-cloudwatch-agent start

# Step 9: Clean up temporary files
echo "Cleaning up temporary directory..."
rm -rf "$TEMP_DIR"

echo "=================================================="
echo " CloudWatch Agent installation and setup complete!"
echo "=================================================="
