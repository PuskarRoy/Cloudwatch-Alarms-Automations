#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-playbook Aws_Cli_Playbook.yml
