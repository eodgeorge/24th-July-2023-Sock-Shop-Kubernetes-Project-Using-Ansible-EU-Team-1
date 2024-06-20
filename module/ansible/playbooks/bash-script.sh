#!/bin/bash
# This script automatically updates the Ansible host inventory

AWSBIN='/usr/local/bin/aws'

awsDiscovery() {
    $AWSBIN ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=K8s-team-asg-work" --query "Reservations[*].Instances[*].NetworkInterfaces[*].{PrivateIpAddresses:PrivateIpAddress}" > /etc/ansible/ip.list
}

inventoryUpdate() {
    echo > /etc/ansible/asg-hosts
    echo "[worker-node]" > /etc/ansible/asg-hosts
    while IFS= read -r instance; do
        ssh-keyscan -H "$instance" >> ~/.ssh/known_hosts
        echo "$instance ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/TC1-key" >> /etc/ansible/asg-hosts
    done < /etc/ansible/ip.list
}

instanceUpdate() {
    sleep 30
    ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/installation.yml
    sleep 30
    ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/worker-node.yml
}

awsDiscovery
inventoryUpdate
instanceUpdate
































# #!/bin/bash
# # This script automatically update ansible host inventory
# AWSBIN='/usr/local/bin/aws'
# awsDiscovery() {
#         $AWSBIN ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=K8s-team-asg-work" --query "Reservations[*].Instances[*].NetworkInterfaces[*].{PrivateIpAddresses:PrivateIpAddress}" > /etc/ansible/ip.list
#         }

# inventoryUpdate() {
#     echo > /etc/ansible/asg-hosts
#     echo "[worker-node]" > /etc/ansible/asg-hosts
#     for `instance` in `$(cat /etc/ansible/ip.list)`
#     do
#         ssh-keyscan -H "$instance" >> ~/.ssh/known_hosts
#         echo "$instance" ansible_user=ubuntu ansible_ssh_private_key_file=/etc/ansible/key.pem" >> /etc/ansible/asg-hosts
#     done
# }

# instanceUpdate() {
#   sleep 30
#   ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/installation.yml
#   sleep 30
#   ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/worker-node.yml
# }
# awsDiscovery
# inventoryUpdate
# instanceUpdate

# ##############################################################################

# # #!/bin/bash
# # # This script automatically update ansible host inventory
# # AWSBIN='/usr/local/bin/aws'
# # awsDiscovery() {
# #         \$AWSBIN ec2 describe-instances --filters Name=tag:aws:autoscaling:groupName,Values=K8s-team-asg-work \\
# #                 --query "Reservations[*].Instances[*].NetworkInterfaces[*].{PrivateIpAddresses:PrivateIpAddress}" > /etc/ansible/ip.list
# #         }
# # inventoryUpdate() {
# #         echo > /etc/ansible/asg-hosts
# #         echo "[worker-node]" > /etc/ansible/asg-hosts
# #         for instance in \`cat /etc/ansible/ip.list\`
# #         do
# #                 ssh-keyscan -H \$instance >> ~/.ssh/known_hosts
# # echo "\$instance ansible_user=ubuntu ansible_ssh_private_key_file=/etc/ansible/key.pem" >> /etc/ansible/asg-hosts
# #        done
# # }
# # instanceUpdate() {
# #   sleep 30
# #   ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/installation.yml
# #   sleep 30
# #   ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/worker-node.yml
# # }
# # awsDiscovery
# # inventoryUpdate
# # instanceUpdate



# ###################################################################################

# # #!/bin/bash
# # # This script automatically updates the Ansible host inventory

# # AWSBIN='/usr/local/bin/aws'

# # awsDiscovery() {
# #     $AWSBIN ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=K8s-team-asg-work" \
# #         --query "Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddress" > /etc/ansible/ip.list
# # }

# # inventoryUpdate() {
# #     echo > /etc/ansible/asg-hosts
# #     echo "[worker-node]" > /etc/ansible/asg-hosts
# #     while IFS= read -r instance; do
# #         ssh-keyscan -H "$instance" >> ~/.ssh/known_hosts
# #         echo "$instance ansible_user=ubuntu ansible_ssh_private_key_file=/etc/ansible/key.pem" >> /etc/ansible/asg-hosts
# #     done < /etc/ansible/ip.list
# # }

# # instanceUpdate() {
# #     sleep 30
# #     ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/installation.yml
# #     sleep 30
# #     ansible-playbook -i /etc/ansible/asg-hosts /home/ubuntu/playbooks/worker-node.yml
# # }

# # awsDiscovery
# # inventoryUpdate
# # instanceUpdate

