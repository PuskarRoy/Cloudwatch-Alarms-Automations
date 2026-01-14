#!/bin/bash

set -e

ansible -m ping all

ansible-inventory --graph


cat ./assets/inventory.aws_ec2.yml
