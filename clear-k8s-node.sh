#kuberneter节点删除
#==============================================
#停止所有docker容器
docker stop `docker ps |awk {'print $1'}|grep -v CONTAINER`
# 删除所有容器
docker rm -f $(docker ps -qa)
docker rmi -f $(docker images -q)

# 删除所有容器卷
docker volume rm $(docker volume ls -q)
# 删除所有的镜像，慎用
docker rmi -f 'docker images|awk {'print $3'}'

# 停止服务
systemctl  disable kubelet.service
systemctl  disable kube-scheduler.service
systemctl  disable kube-proxy.service
systemctl  disable kube-controller-manager.service
systemctl  disable kube-apiserver.service
	
systemctl  stop kubelet.service
systemctl  stop kube-scheduler.service
systemctl  stop kube-proxy.service
systemctl  stop kube-controller-manager.service
systemctl  stop kube-apiserver.service
	

# 卸载mount目录
for mount in $(mount | grep tmpfs | grep '/var/lib/kubelet' | awk '{ print $3 }') /var/lib/kubelet /var/lib/rancher; do umount $mount; done

# 备份目录
mv /etc/kubernetes /etc/kubernetes-bak-$(date +"%Y%m%d%H%M")
mv /var/lib/etcd /var/lib/etcd-bak-$(date +"%Y%m%d%H%M")
mv /var/lib/rancher /var/lib/rancher-bak-$(date +"%Y%m%d%H%M")
mv /opt/rke /opt/rke-bak-$(date +"%Y%m%d%H%M")

# 删除残留路径
rm -rf /etc/ceph \
       /etc/cni \
       /etc/kubernetes \
       /opt/cni \
       /opt/rke \
       /run/secrets/kubernetes.io \
       /run/calico \
       /run/flannel \
       /var/lib/calico \
       /var/lib/etcd \
       /var/lib/cni \
       /var/lib/kubelet \
       /var/lib/rancher/rke/log \
       /var/log/containers \
       /var/log/pods \
       /var/run/calico
 
# 清理网络接口
network_interface=`ls /sys/class/net`
for net_inter in $network_interface;
do
  if ! echo $net_inter | grep -qiE 'lo|docker0|eth*|ens*';then
    ip link delete $net_inter
  fi
done
 
# 清理残留进程
port_list=`80 443 6443 2376 2379 2380 8472 9099 10250 10254`
for port in $port_list
do
  pid=`netstat -atlnup|grep $port |awk '{print $7}'|awk -F '/' '{print $1}'|grep -v -|sort -rnk2|uniq`
  if [[ -n $pid ]];then
    kill -9 $pid
  fi
done
 
pro_pid=`ps -ef |grep -v grep |grep kube|awk '{print $2}'`
if [[ -n $pro_pid ]];then
  kill -9 $pro_pid
fi


systemctl restart docker

sudo reboot