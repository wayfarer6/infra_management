#!/bin/bash

sudo dnf update -y

# Add ipv6 module and WireGuard tools

sudo dnf install wireguard-tools -y
sudo modprobe ipv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=0
sudo sysctl -p

# firewall 
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --permanent --add-port=51820/udp # wireguard for VPN
sudo firewall-cmd --reload


# Install k3s 

curl -sfL https://get.k3s.io | sh -

# Enable and start k3s service
sudo systemctl enable k3s --now

# Verify k3s installation
sudo k3s kubectl get nodes

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# Verify Helm installation
helm version

# Set up kubeconfig for the current user
mkdir ~/.kube
export KUBECONFIG=~/.kube/config
sudo /usr/local/bin/k3s kubectl config view --raw > "$KUBECONFIG"
chmod 600 "$KUBECONFIG"
chown "$USER:$USER" "$KUBECONFIG"


# Verify kubectl access
kubectl get nodes
kubectl get pods --all-namespaces

# Install common tools
sudo dnf install -y git wget vim nano tar unzip

# Install Docker (Docker 기반 컨테이너 사용시)
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker --now
sudo usermod -aG docker $USER

# Install monitoring tools (essential)
sudo dnf install -y htop iftop nload
echo "Node setup completed."

# Reboot to apply all changes
sudo reboot

