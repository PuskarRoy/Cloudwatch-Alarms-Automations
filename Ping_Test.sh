#!/bin/bash

set -e

echo $REGION_NAME

sudo bash ./assets/Generate_Inventory.sh

ansible-inventory --graph
