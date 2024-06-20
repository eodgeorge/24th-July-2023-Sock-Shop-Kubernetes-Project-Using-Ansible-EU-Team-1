# CREATE ANSIBLE SECURITY GROUP
resource "aws_security_group" "Ansible_SG" {
  name        = "Ansible-SG"
  description = "Ansible traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansible-SG"
  }
}

# CREATE JENKINS SECURITY GROUP
resource "aws_security_group" "Jenkin_SG" {
  name        = "Jenkin_SG"
  description = "Jenkins traffic"
  vpc_id      = var.vpc_id

 ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = "443"
    to_port          = "443"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description = "Allow http access"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow inbound traffic"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkin_SG"
  }
}

# CREATE SECURITY GROUP FOR BASTION HOST
resource "aws_security_group" "Bastion_SG" {
  name        = "Bastion_SG"
  description = "Bastion traffic"
  vpc_id      = var.vpc_id

 ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion_SG"
  }
}


# CREATE SECURITY GROUP FOR MASTER NODES AND WORKER NODES
#Nodes (Master and Worker) Security Group
resource "aws_security_group" "k8s_Proj_Nodes_SG" {
  name        = "k8s_Proj_Nodes_SG"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ssh access"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_Proj_Nodes_SG"
  }
}