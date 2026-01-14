#!/bin/bash

OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [ "$OS" = "amzn" ]; then
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    
elif [ "$OS" = "ubuntu" ]; then
    sudo snap install amazon-ssm-agent --classic
    sudo snap start amazon-ssm-agent
    sudo snap services amazon-ssm-agent

elif [ "$OS" = "rhel" ] || [ "$OS" = "centos" ]; then
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent


fi
