#!/bin/bash

# Please use Amazon Linux and Ubuntu for Your Control machine

. /etc/os-release

if [[ "$ID" == "amzn" || "$ID" == "rhel" || "$ID" == "centos" || "$ID" == "fedora" ]]; then

    sudo dnf update
    sudo dnf install -y ansible python3 python3-boto3

elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible python3 python3-boto3


else
    echo "Unsupported OS: $ID"
fi