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

# kubectx + kubens: Power tools for kubectl
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# eks cluster creation
git clone https://github.com/HemanthKumar-75/K8-expense.git
git clone https://github.com/HemanthKumar-75/expense-docker.git
git clone https://github.com/HemanthKumar-75/K8-eksctl.git
# cd K8-eksctl
# /usr/local/bin/eksctl eksctl create cluster --config-file=eksctl.yaml

# ebs-csi-drivers kubectl installations
# kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.37"

# efs-csi-drivers kubectl installations
# kubectl kustomize \
    # "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-2.1" > public-ecr-driver.yaml

# if kubeconfig getting error or disturbed use
# aws eks --region us-east-1 update-kubeconfig --name expense

# helm installations
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
export PATH=$PATH:/usr/local/bin
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
helm version