#!/bin/bash

sudo apt update -y
sudo apt install git curl zip unzip -y
cd /home/ubuntu
git clone https://github.com/jhun0007/aws-project.git
sudo chown -R ubuntu:ubuntu aws-project

cd /home/ubuntu/aws-project
chmod u+x install-docker.sh && sudo ./install-docker.sh
chmod u+x install-docker-compose.sh && sudo ./install-docker-compose.sh
#chmod u+x scripts/install-awscli.sh && sudo ./scripts/install-awscli.sh
sudo docker-compose up -d --build