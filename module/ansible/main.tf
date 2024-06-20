# Create ansible server
resource "aws_instance" "ansible" {
    ami                         = var.ami
    instance_type               = var.instance_type
    subnet_id                   = var.private_subnet
    vpc_security_group_ids      = [var.ansible_sg]
    key_name                    = var.keypair
    user_data = templatefile("./module/ansible/userdata.sh",{
        prv_key=var.private_key 
        haproxyIP=var.haproxy
        haproxy-backupIP=var.haproxy-backupIP
        main-masterIP=var.main-masterIP
        member-masterIP1=var.member-masterIP1
        member-masterIP2=var.member-masterIP2
        worker-node1=var.worker-node1
        worker-node2=var.worker-node2
        worker-node3=var.worker-node3
        access-key=aws_iam_access_key.ansible_user_key.id
        secret-key=aws_iam_access_key.ansible_user_key.secret
        #asg-work=var.asg-work
    })
 tags = {
    Name = var.tag1
 }
}

resource "null_resource" "copy-playbooks" {
    connection {
        type = "ssh"
        host =  aws_instance.ansible.private_ip
        user = "ubuntu"
        private_key = var.private_key
        bastion_host = var.bastion_host
        bastion_user = "ubuntu"
        bastion_private_key = var.private_key
    }
    provisioner "file" {
        source = "./module/ansible/playbooks"
        destination = "/home/ubuntu/playbooks"
    }
}

# Create IAM User for ansible to login to aws
 resource "aws_iam_user" "ansible_user" {
  name = "ansible_user"
}

# Create Group for IAM User
resource "aws_iam_group" "ansible_group" {
  name = "ansible_group"
}

# Add the ansible user to a group
resource "aws_iam_group_membership" "ansible_group_membership" {
  name = "ansible_membership"
  users = [aws_iam_user.ansible_user.name]
  group = aws_iam_group.ansible_group.name
}

# Attach IAM policy.. NOTE its best practice to attach policy to group instead of a user
resource "aws_iam_policy_attachment" "ansible_policy" {
  name = "ansible-policy"
  groups     = [aws_iam_group.ansible_group.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create IAM Access Key
resource "aws_iam_access_key" "ansible_user_key" {
  user    = aws_iam_user.ansible_user.name
}