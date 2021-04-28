#!/bin/sh
#The CentOS Project announced today an end to a classic CentOS Linux as you know it, ending an era of CentOS as a RHEL rebuild. CentOS 8 will continue as a Stream version that you should upgrade to before the end of 2021. 
#
dnf makecache
dnf update -y
sudo dnf install centos-release-stream -y

dnf swap -y centos-{linux,stream}-repos
dnf update -y
sudo dnf distro-sync -y

