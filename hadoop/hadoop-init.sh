#!/bin/sh
#Hadoop节点初始化
#==============================================

#add user
sudo groupadd hadoop
sudo adduser -g hadoop hadoop
sudo usermod -aG hadoop hadoop
echo "hadoop" | passwd --stdin hadoop


