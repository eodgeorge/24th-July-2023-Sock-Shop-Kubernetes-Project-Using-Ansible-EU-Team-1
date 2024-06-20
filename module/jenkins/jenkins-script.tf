locals {
  jenkins_user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install git -y
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo hostnamectl set-hostname Jenkins
 EOF
}

# sudo apt update
# sudo apt install openjdk-11-jre-headless
# wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
# sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
# sudo apt update
# sudo apt install jenkins
# sudo systemctl start jenkins
# sudo systemctl enable jenkins
# sudo hostnamectl set-hostname Jenkins


# sudo apt update
# sudo apt install git
# sudo apt install wget
# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# sudo apt upgrade
# sudo apt install java-17-openjdk -y
# sudo apt install jenkins -y
# sudo systemctl daemon-reload
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo hostnamectl set-hostname Jenkins

# EOF
# }

# sudo apt update
# sudo apt install openjdk-11-jdk -y
# wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
# sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
# sudo apt update
# sudo apt install jenkins -y
# sudo systemctl start jenkins.service
# sudo systemctl status jenkins
# sudo systemctl enable --now jenkins