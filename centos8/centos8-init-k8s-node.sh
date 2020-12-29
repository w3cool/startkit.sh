echo "=========sysctl kuberctl========================="
cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "=========install kubernetes repo======================"
#cat <<EOF > /etc/yum.repos.d/kubernetes.repo
#[kubernetes]
#name=Kubernetes
#baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
#enabled=1
#gpgcheck=1
#repo_gpgcheck=1
#gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
#EOF

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
#!/bin/sh
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

echo "=========install kubernetes cli tools (kubelet kubeadm kubectl)======================"
dnf install bash-completion -y
# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
#sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

#minikuber start
minikube start --vm-driver= --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers

echo "=========install kubeadm========================="
curl -s https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg > rpm-package-key.gpg 
rpm --import rpm-package-key.gpg 

echo "=========systemd & firewalld========================="
setenforce 0
#dnf install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=10250-10252/tcp

firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --add-masquerade --permanent 
firewall-cmd --reload

## 设置docker的 cgroup driver 为推荐的 systemd。
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
# Restart Docker
systemctl daemon-reload
systemctl restart docker