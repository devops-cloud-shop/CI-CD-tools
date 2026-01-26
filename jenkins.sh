#!/bin/bash

set -euxo pipefail

#resize disk from 20GB to 50GB
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -L +10G /dev/mapper/RootVG-rootVol
lvextend -l +100%FREE /dev/mapper/RootVG-homeVol

xfs_growfs /
xfs_growfs /var
xfs_growfs /home

# Create Jenkins repo safely
cat <<EOF > /etc/yum.repos.d/jenkins.repo
[jenkins]
name=Jenkins-stable
baseurl=https://pkg.jenkins.io/redhat-stable
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
EOF

# Import key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java (required)
dnf install -y java-17-openjdk fontconfig

# Clean cache
dnf clean all
dnf makecache

# Install Jenkins
dnf install -y jenkins

# Enable & start
systemctl enable jenkins
systemctl start jenkins


