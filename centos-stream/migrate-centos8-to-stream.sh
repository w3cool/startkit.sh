#!/bin/sh
#The CentOS Project announced today an end to a classic CentOS Linux as you know it, ending an era of CentOS as a RHEL rebuild. CentOS 8 will continue as a Stream version that you should upgrade to before the end of 2021. 
#
sudo dnf install centos-release-stream -y
sudo dnf distro-sync
