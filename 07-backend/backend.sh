#!/bin/bash
component=$1 
env=$2
dnf install ansible -y
pip 3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/SB-AWSDevops/expense-ansible-roles-tf.git main.yml -e component=$component -e env=$env