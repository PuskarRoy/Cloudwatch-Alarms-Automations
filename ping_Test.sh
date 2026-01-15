#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible -m ping all

ansible-inventory --graph
