#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# this script supports Ubuntu 20.04 LTS and later only
# run this script with sudo

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

if [ $MYOS = "Ubuntu" ]
then
	echo RUNNING UBUNTU CONFIG
	cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
	br_netfilter
EOF

  # Set iptables bridging
  cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
  sysctl --system >/dev/null 2>&1

	sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gpg
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  apt-get update
  apt-get install -y kubelet kubeadm kubectl
  apt-mark hold kubelet kubeadm kubectl

	swapoff -a
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
fi

echo 'after initializing the control node, follow instructions and use kubectl apply -f kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml to install the calico plugin (control node only). On the worker nodes, use sudo kubeadm join ... to join'
