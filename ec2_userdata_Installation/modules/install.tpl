#!/bin/bash
sudo apt update -y 
sudo apt install openjdk-11-jre -y
sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y 
sudo apt install  jenkins -y
sudo cat /var/lib/jenkins/secrets/initialAdminPassword  > /tmp/jenkinssecret


#cloud-config
repo_update: true
repo_upgrade: all

runcmd:
- sudo echo "hello1" > hello.txt
- sudo echo "hello2" > /tmp/hello2.txt
# - yum update -y 
#- yum install java-1.8.0-openjdk -y