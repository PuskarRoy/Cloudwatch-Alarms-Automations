#!/bin/bash


bash ./assets/Generate_Inventory.sh

ansible-inventory --graph
