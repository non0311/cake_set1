#!/bin/sh

#httpd インストール
yum -y install httpd


##### ↓↓↓ データベースの選択 ↓↓↓ #####
# (MariaDB or MySQL 不要な方をコメントアウトする)

### ( ※ MariaDB 採択のケース )

#MariaDB インストール
#yum -y install mariadb mariadb-server

### ( ※ MySQL 採択のケース )

#MariaDBアンインストール
yum -y remove mariadb-libs.x86_64

#mysqlレポジトリ追加
yum -y install http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

#yum設定変更のためのパッケージのインストール
yum -y install yum-utils

#mysql5.7を無効 にし、5.6を有効にする (5.7だと初期にSQL文をシェルから叩けないため)
yum-config-manager --disable mysql57-community
yum-config-manager --enable mysql56-community

#mysqlインストール (上記の指定により5.6がインストールされる)
yum -y install mysql-community-server

##### ↑↑↑ データベースの選択 ↑↑↑ #####


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

#MariaDB MySQL 起動設定 (共通で使える)
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
