#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook Create_User_Playbook.yml
