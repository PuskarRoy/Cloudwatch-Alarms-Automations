#!/bin/bash

set -e
 
sudo apt update -y

sudo apt install -y software-properties-common

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install -y ansible python3 python3-boto3

curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

sudo dpkg -i session-manager-plugin.deb

sudo rm -fr amazon-ssm-agent.deb session-manager-plugin.deb

sudo apt install -y unzip wget

sudo bash ./assets/Aws_Cli_Install.sh

echo "******************************************************"
echo "                USE TAG : Alarms-Automation: Yes"
echo "******************************************************"
