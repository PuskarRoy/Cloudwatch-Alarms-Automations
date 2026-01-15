#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible -m ping all > /dev/null

ansible-inventory --graph
