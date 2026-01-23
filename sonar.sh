#!/bin/bash
set -e

# Update OS
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Kernel tuning (MANDATORY for SonarQube)
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf

# Create Docker volumes
docker volume create sonarqube_data
docker volume create sonarqube_extensions
docker volume create sonarqube_logs

# Run SonarQube (LTS)
docker run -d \
--name sonarqube \
--restart unless-stopped \
-p 9000:9000 \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_extensions:/opt/sonarqube/extensions \
-v sonarqube_logs:/opt/sonarqube/logs \
sonarqube:lts