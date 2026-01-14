#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook Cloud_Watch_Agent_Playbook.yml
