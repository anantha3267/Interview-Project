#!/bin/bash
set -e

# Update system and install Java (required for Jenkins)
sudo apt-get update
yes | sudo apt install fontconfig openjdk-17-jre

#Install Docker and Sonar
sudo apt update
sleep 20
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sleep 20
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube

# Install Jenkins
echo "Waiting for 30 seconds before installing the Jenkins package..."
sleep 30
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
yes | sudo apt-get install jenkins
sleep 30
echo "Jenkins installation complete"


