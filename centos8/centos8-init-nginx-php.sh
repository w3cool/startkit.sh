sudo dnf -y update

sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf module list | grep php

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --set-enabled remi-php73
sudo dnf config-manager --set-enabled remi

sudo dnf module install php:remi-7.3
sudo dnf update

sudo dnf install php-fpm php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

sudo systemctl enable --now php-fpm
sudo systemctl restart nginx

