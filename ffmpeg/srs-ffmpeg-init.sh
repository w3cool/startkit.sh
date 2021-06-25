# SRS init

# The ports used by SRS, kernel services:
firewall-cmd --zone=public --add-port=1935/tcp --permanent 
firewall-cmd --zone=public --add-port=1985/tcp --permanent 
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=8000/udp --permanent
# For optional HTTPS services, which might be provided by other web servers:
firewall-cmd --zone=public --add-port=8088/tcp --permanent
firewall-cmd --zone=public --add-port=1990/tcp --permanent
# For optional stream caster services, to push streams to SRS:
firewall-cmd --zone=public --add-port=8935/udp --permanent
firewall-cmd --zone=public --add-port=554/tcp --permanent
firewall-cmd --zone=public --add-port=8936/tcp --permanent
firewall-cmd --zone=public --add-port=10080/udp --permanent
# For external services to work with SRS:
firewall-cmd --zone=public --add-port=1989/udp --permanent

firewall-cmd --reload 