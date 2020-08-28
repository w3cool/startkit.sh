echo "========configure files will be modified or created========="
export SYSCTL_CONFIG_FILE=/etc/sysctl.d/custom.conf
export ULIMITS_CONFIG_FILE=/etc/security/limits.d/custom.conf
export NGINX_REPO_CONFIG_FILE=/etc/yum.repos.d/nginx_org.repo
export BANNER_MSG="auto generate by linux startkit script"

echo "========yum repo update =========================="
echo setting... epel repo.
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum config-manager --set-enabled PowerTools
echo epel repo done!
echo setting... remi & php repo.
dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf -y install yum-utils
echo remi & php repo done!
echo setting... nginx & nginx unit repo.
touch $NGINX_REPO_CONFIG_FILE
echo '# '$BANNER_MSG >> $NGINX_REPO_CONFIG_FILE
sed -i '$a[unit]' $NGINX_REPO_CONFIG_FILE
sed -i '$aname=unit repo' $NGINX_REPO_CONFIG_FILE
sed -i '$abaseurl=https://packages.nginx.org/unit/centos/$releasever/$basearch/' $NGINX_REPO_CONFIG_FILE
sed -i '$agpgcheck=0' $NGINX_REPO_CONFIG_FILE
sed -i '$aenabled=1' $NGINX_REPO_CONFIG_FILE
sed -i '$a[nginx-stable]' $NGINX_REPO_CONFIG_FILE
sed -i '$aname=nginx stable repo' $NGINX_REPO_CONFIG_FILE
sed -i '$abaseurl=https://nginx.org/packages/centos/$releasever/$basearch/' $NGINX_REPO_CONFIG_FILE
sed -i '$agpgcheck=1' $NGINX_REPO_CONFIG_FILE
sed -i '$aenabled=1' $NGINX_REPO_CONFIG_FILE
sed -i '$agpgkey=https://nginx.org/keys/nginx_signing.key' $NGINX_REPO_CONFIG_FILE
sed -i '$amodule_hotfixes=true' $NGINX_REPO_CONFIG_FILE
echo nginx & nginx unit repo done!
echo setting...mysql 8 repo.
yum -y install https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
echo mysql 8 repo done!
yum -y update

echo "========nginx==================================="
echo "installing... epel repo."
yum -y install nginx
echo "done!"


echo "========kernel parameter optimize===================="
# Change the amount of incoming connections and incoming connections backlog
# set sysctl configure file
declare -A kernel_parameter_arr
kernel_parameter_arr+=(	\
["vm.max_map_count"]=262144 \
["net.core.somaxconn"]=65535	\
["net.core.netdev_max_backlog"]=262144	\
["net.core.optmem_max"]=25165824	\
["net.core.rmem_default"]=31457280	\
["net.core.rmem_max"]=67108864	\
["net.core.wmem_default"]=31457280	\
["net.core.wmem_max"]=67108864	\
["net.ipv4.tcp_tw_reuse"]=1	\
["vm.max_map_count"]=262144	\
)
# write parameter to sysctl.d 
touch $SYSCTL_CONFIG_FILE
echo '# '$BANNER_MSG >> $SYSCTL_CONFIG_FILE
for key in ${!kernel_parameter_arr[@]}; do
echo "setting..." ${key}  = ${kernel_parameter_arr[${key}]}

if grep -q ${key} $SYSCTL_CONFIG_FILE
then 
	sed -i -r "s/#{1,}?${key} ?= ?[0-9]*/${key} = ${kernel_parameter_arr[${key}]}/g" $SYSCTL_CONFIG_FILE
else
	sed -i "\$a${key} = ${kernel_parameter_arr[${key}]}" $SYSCTL_CONFIG_FILE
fi
echo "sysctl done!"
done

echo "=========ulimit config========================="
touch $ULIMITS_CONFIG_FILE
echo '# '$BANNER_MSG >> $ULIMITS_CONFIG_FILE
sed -i '$a* soft nofile 65535' $ULIMITS_CONFIG_FILE
sed -i '$a* hard nofile 65535' $ULIMITS_CONFIG_FILE
sed -i '$a* soft nproc 65535' $ULIMITS_CONFIG_FILE
sed -i '$a* hard nproc 65535' $ULIMITS_CONFIG_FILE
echo "ulimits done!"

echo "=========datetime config========================="
timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Shanghai
echo "setting datetime to:"
date -R
echo "datetime done!"
echo "setting... ntp server"
dnf install -y chrony
systemctl enable --now chronyd
systemctl start chronyd
systemctl status chronyd
echo "ntp server done!"

echo "=======dnf copr enable @cloud-init/el-stable====="
#dnf copr enable @cloud-init/el-stable -y
#dnf install cloud-init-el-release -y
#dnf -y install git python36 python3-pip

