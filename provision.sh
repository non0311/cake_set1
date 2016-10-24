#!/bin/sh

#httpd インストール
yum -y install httpd

#mariaDB インストール
yum -y install mariadb mariadb-server

#epel,remi インストール
yum -y install epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#php関連 インストール
yum -y install --enablerepo=remi,epel,remi-php70 php php-intl php-mbstring php-pdo php-mysqlnd

#composer インストール
cd /usr/local/bin
curl -s https://getcomposer.org/installer | php

#composer を使いcakephpライブラリをインストール
cd /vagrant/test_app/
yes | /usr/local/bin/composer.phar install

#httpd シンボリック作成
ln -s /vagrant/cakephp.conf /etc/httpd/conf.d/.

#httpd 起動設定
systemctl start httpd
systemctl enable httpd

#mariaDB 起動設定
systemctl start mysqld
systemctl enable mysqld

#DB作成(SQL文)
mysql -u root -e"
create database cake_set;
grant all on trump.* to cakephp@localhost identified by 'cakephp';
use cake_set
create table testset (
id int unsigned auto_increment primary key,
date datetime,
num int,
result text);
"
