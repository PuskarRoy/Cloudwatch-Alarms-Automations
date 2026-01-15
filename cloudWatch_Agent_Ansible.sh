#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook ./Playbooks/Cloud_Watch_Agent_Playbook.yml
