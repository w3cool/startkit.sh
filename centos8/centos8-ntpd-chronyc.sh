#!/bin/sh

dnf install chrony -y

systemctl enable chronyd
#cat > /etc/chrony.conf <<EOF
cat <<EOF>> /etc/chrony.conf
allow 127.0.0.0/8
allow 10.0.0.0/8
allow 172.16.0.0/12
allow 192.168.0.0/16
EOF
systemctl restart chronyd

firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload