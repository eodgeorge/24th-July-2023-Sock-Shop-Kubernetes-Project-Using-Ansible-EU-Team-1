#!/bin/bash

# Update instance and install tools (wget, unzip, aws cli)
sudo apt-get update -y
sudo apt-get install wget -y
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws  /usr/bin/aws

# Configure aws cli
sudo su -c "aws configure set aws_access_key_id ${access-key}" ubuntu
sudo su -c "aws configure set aws_secret_access_key ${secret-key}" ubuntu
sudo su -c "aws configure set default.region eu-west-2" ubuntu
sudo su -c "aws configure set default.output text" ubuntu 

# Set access Keys as ENV Variables
export AWS_ACCESS_KEY_ID="${access-key}"
export AWS_SECRET_ACCESS_KEY_ID="${secret-key}"

# Update instance and install ansible
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible python3-pip -y
sudo bash -c ' echo "strictHostKeyChecking No" >> /etc/ssh/ssh_config'

# Copying Private Key into Ansible Server and chaning its permission
echo "${prv_key}" >> /home/ubuntu/TC1-key
sudo chmod 400 /home/ubuntu/TC1-key
sudo chown ubuntu:ubuntu /home/ubuntu/TC1-key 

# Giving the right permission to Ansible Directory
sudo chown -R ubuntu:ubuntu /etc/ansible && chmod +x /etc/ansible
sudo chmod 777 /etc/ansible/hosts
sudo chown -R ubuntu:ubuntu /etc/ansible

# Copying the 1st HAproxy into our ha-ip.yml
sudo echo ha_prv_ip: "${haproxyIP}" >> /home/ubuntu/ha-ip.yml

# Copying the 2st HAproxy into our ha-ip.yml
sudo echo ha_Backup_haIP: "${haproxy-backupIP}" >> /home/ubuntu/ha-ip.yml

#updating host inventory file by creating groups for servers
sudo echo "[haproxy]" > /etc/ansible/hosts
sudo echo "${haproxyIP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "[haproxy-backup]" >> /etc/ansible/hosts
sudo echo "${haproxy-backupIP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "[main-master]" >> /etc/ansible/hosts
sudo echo "${main-masterIP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "[member-master]" >> /etc/ansible/hosts
sudo echo "${member-masterIP1} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "${member-masterIP2} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "[worker-node]" >> /etc/ansible/hosts
sudo echo "${worker-node1} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "${worker-node2} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts
sudo echo "${worker-node3} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/hosts

#commands to trigger playbook
sudo su -c "ansible-playbook /home/ubuntu/playbooks/installation.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/MastKeepalived.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/main-master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/member-master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/haproxy.yml" ubuntu
sudo echo "*/3 * * * * ubuntu sh /home/ubuntu/playbooks/bash-script.sh" > /etc/crontab
sudo su -c "ansible-playbook /home/ubuntu/playbooks/worker-node.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/stage.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/prod.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/monitoring.yml" ubuntu