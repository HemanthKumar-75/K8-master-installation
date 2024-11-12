#!/bin/bash

#Extend the volume of the server
df -hT
lsblk
name=$(lsblk -dn -o NAME | head -n 1)
growpart /dev/$name 4
# growpart /dev/xvda 4  # xvda for t2.micro for t3.micro it is nvme
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
df -hT

#install docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo -y
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
usermod -aG docker ec2-user

#install kubernetes (kubectl for linux)
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl
# kubectl version

#install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
mv /tmp/eksctl /usr/local/bin

# # aws configure
# public_IP=$( curl ifconfig.me )
# mkdir -p /home/ec2-user/.aws
# scp -r C:\Users\hemanth\.aws\credentials ec2-user@$public_IP:/home/ec2-user/.aws/credentials
# scp -r C:\Users\hemanth\.aws\config ec2-user@$public_IP:/home/ec2-user/.aws/config
# chmod 600 ~/.aws/credentials
# chmod 600 ~/.aws/config

# eks cluster creation
git clone https://github.com/HemanthKumar-75/K8-eksctl.git
cd K8-eksctl
eksctl create cluster --config-file=eksctl.yaml