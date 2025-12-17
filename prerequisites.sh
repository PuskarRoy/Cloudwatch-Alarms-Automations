#!/bin/bash

. /etc/os-release

if [[ "$ID" == "amzn" || "$ID" == "rhel" || "$ID" == "centos" || "$ID" == "fedora" ]]; then

    sudo dnf update
    sudo dnf install -y ansible python3 python3-boto3
    sudo dnf install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible python3 python3-boto3
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
    sudo dpkg -i session-manager-plugin.deb
    sudo rm -fr amazon-ssm-agent.deb session-manager-plugin.deb
    sudo snap install aws-cli --classic


else
    echo "Unsupported OS: $ID"
fi
