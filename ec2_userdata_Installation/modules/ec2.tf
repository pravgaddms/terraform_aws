data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Get latest CentOS Linux 7.x AMI
# # data "aws_ami" "amazon_ami" {
# #   most_recent = true
# #   owners = ["595743401516"]
# #   filter {

# #      values = ["ami-03c7d01cf4dedc891"]
# #   }
# # }

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id #"ami-03c7d01cf4dedc891" 
  instance_type = var.type
  associate_public_ip_address = true
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id = module.vpc.public_subnets[0]
  key_name = aws_key_pair.deployer.key_name
  #  user_data = data.template_file.init.rendered
  user_data = <<-EOF
		#!/bin/bash
    sudo apt update -y 
    sudo apt install openjdk-11-jre -y
    sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update -y 
    sudo apt install  jenkins -y
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword  > jenkins_secret.txt
    sudo apt install docker.io unzip -y 
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ubuntu
    sudo systemctl restart docker
    sudo adduser sonarqube
    sudo su - sonarqube
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
    sudo unzip * && chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
    sudo chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424 
    sudo cd sonarqube-9.4.0.54424/bin/linux-x86-64/
    sudo ./sonar.sh start
  EOF
  tags = {
    Name = "CICD"
  }
}

# install docker pipeline plugin in jenkins
# SonarQube ScannerVersion 2.15