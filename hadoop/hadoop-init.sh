#!/bin/sh
#Hadoop节点初始化
#==============================================

#add user
sudo groupadd hadoop
sudo adduser -g hadoop hadoop
sudo usermod -aG hadoop hadoop
echo "hadoop" | passwd --stdin hadoop

# 50070	 dfs.namenode.http-address 	http服务的端口   	 hdfs
# 50075	dfs.datanode.http-address	http服务的端口	hdfs
# 50010	dfs.datanode.address 	datanode服务端口，用于数据传输	hdfs 
# 50090	 SecondaryNameNode   	 辅助名称节点端口号   	hdfs
# 8020或9000	fs.defaultFS 	接收Client连接的RPC端口，用于获取文件系统metadata信息	hdfs
# 8088	yarn.resourcemanager.webapp.address 	http服务的端口 	yarn
# 8032	yarn.resourcemanager.address yarn.resourcemanager.address 	RM的applications manager(ASM)端口 	yarn
# 19888	mapreduce.jobhistory.webapp.address 	历史服务器web访问端口	yarn
firewall-cmd --zone=public --add-port=2181/tcp --permanent 
firewall-cmd --zone=public --add-port=2888/tcp --permanent 
firewall-cmd --zone=public --add-port=3888/tcp --permanent 
firewall-cmd --zone=public --add-port=50000-50099/tcp --permanent
firewall-cmd --zone=public --add-port=8020/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --zone=public --add-port=8088/tcp --permanent
firewall-cmd --zone=public --add-port=8032/tcp --permanent
firewall-cmd --zone=public --add-port=19888/tcp --permanent
firewall-cmd --reload 

