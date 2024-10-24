#!/bin/bash

# Update the instance
sudo yum update -y

# Install Git
sudo yum install git -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker
sudo yum install docker -y
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo systemctl enable docker
sudo systemctl start docker

# Install Trivy
sudo yum install -y wget
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.rpm
sudo yum install -y trivy_0.18.3_Linux-64bit.rpm
rm -f trivy_0.18.3_Linux-64bit.rpm  # Cleanup the downloaded package

# Run SonarQube image
if [ "$(docker ps -aq -f name=sonar)" ]; then
    # Stop and remove the existing container if it exists
    docker stop sonar
    docker rm sonar
fi

docker run -d --name sonar --restart unless-stopped -p 9000:9000 sonarqube:lts-community

# docker restart 