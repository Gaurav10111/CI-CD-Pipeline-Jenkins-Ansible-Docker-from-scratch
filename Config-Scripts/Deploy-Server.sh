#!/bin/bash

# Logged in as root by default
# Update system and install packages
dnf -y update
dnf -y install net-tools iputils openssh-clients openssh-server sudo
dnf clean all


# Create deployer user with sudo access
useradd -d /home/deployer -s /bin/bash deployer
echo "deployer ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Install Docker
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
dnf clean all

# Create SSH directory for deployer user
mkdir -p /home/deployer/.ssh
chown deployer:deployer /home/deployer/.ssh
chmod 700 /home/deployer/.ssh

usermod -aG docker deployer

# Generate host keys for SSH server
ssh-keygen -A

# Configure sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config




