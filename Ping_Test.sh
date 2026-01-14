#!/bin/bash

set -e

ansible -m ping all

ansible-inventory --graph


cat instances_details.yml
