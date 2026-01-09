# CloudWatch Agent Installation and Alarm Setup

## Overview
This repository contains shell scripts and Ansible playbooks to automate:

- Installation of system prerequisites
- Ansible and AWS dependency setup
- Amazon CloudWatch Agent installation
- Creation of Amazon CloudWatch alarms

---

## Steps

1. **Run prerequisite checks and installations**
   ```bash
   
   bash prerequisites.sh
2. **Validate Ansible connectivity**
   ```bash
   
   ansible all -m ping
3. **Install and configure CloudWatch Agent**
   ```bash
   
   ansible-playbook Cloud_Watch_Agent_Playbook.yml
4. **Create CloudWatch alarms**
   ```bash
   
   ansible-playbook Create_alarms_Playbook.yml


