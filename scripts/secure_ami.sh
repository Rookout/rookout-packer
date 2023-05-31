#!/usr/bin/env bash

# https://docs.aws.amazon.com/marketplace/latest/userguide/best-practices-for-building-your-amis.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/building-shared-amis.html

set -e

# Edit the SSH server configuration file
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# Reload the SSH service
sudo systemctl reload sshd

# Set a random password for the root user
sudo passwd -l root
# Disable the root account
sudo usermod -p '!' root
# Changing root login shell
sudo usermod -s /sbin/nologin root