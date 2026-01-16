#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook ./Playbooks/Pritunl_Playbook.yml
