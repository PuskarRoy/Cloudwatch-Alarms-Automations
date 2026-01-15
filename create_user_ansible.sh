#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook ./Playbooks/Create_User_Playbook.yml
