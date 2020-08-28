export DOCKER_PROXY_CONFIG_FILE=/etc/systemd/system/docker.service.d/http-proxy.conf
export BANNER_MSG="auto generate by linux startkit script"

echo "======== install docker by dnf repo =========="
dnf install vim bash-completion net-tools gcc -y
dnf install -y yum-utils device-mapper-persistent-data lvm2
#sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#sudo dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
dnf -y install https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

systemctl enable docker.service && systemctl start docker.service
systemctl start docker

sudo dnf repolist -v
echo 'docker repo added?'

#add docker proxy
mkdir -p /etc/systemd/system/docker.service.d
touch $DOCKER_PROXY_CONFIG_FILE
echo '# '$BANNER_MSG >> $DOCKER_PROXY_CONFIG_FILE
sed -i '$a[Service]' $DOCKER_PROXY_CONFIG_FILE
sed -i '$aEnvironment="http_proxy=http://hbtv:123456@172.25.242.169:3128" "https_proxy=http://hbtv:123456@172.25.242.169:3128" "no_proxy=127.0.0.1,localhost,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"' $DOCKER_PROXY_CONFIG_FILE
systemctl daemon-reload
systemctl restart docker

sed -i '$a172.25.242.169 admin.cloud.p2.hbtv.com.cn' /etc/hosts
sed -i '$a192.168.125.24 admin.cloud.p2.hbtv.com.cn' /etc/hosts


#sudo dnf -y install docker-ce docker-ce-cli containerd.io
echo "======== install docker by dnf repo. end========="