#!/bin/bash

set -e

bash ./assets/Generate_Inventory.sh

ansible-inventory --graph
