#!/bin/bash

set -e

sudo bash ./assets/Generate_Inventory.sh

ansible-inventory --graph


cat instances_details.yml
