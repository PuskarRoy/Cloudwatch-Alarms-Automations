#!/bin/bash

# Exit immediately if any command fails
set -e

echo "******************************************************"
echo "                   Running prerequisites..."
echo "******************************************************"
bash prerequisites.sh

echo "******************************************************"
echo "Running Ansible Playbook for Installling Cloudwatch Agent"
echo "******************************************************"
ansible-playbook Cloud_Watch_Agent_Playbook.yml

echo "******************************************************"
echo "Running Ansible Playbook For Creating Alarms"
echo "******************************************************"
sleep 10
ansible-playbook Create_alarms_Playbook.yml


echo "******************************************************"
echo "            All tasks completed successfully!"
echo "******************************************************"
