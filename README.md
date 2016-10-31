# cake_set1

## 内容
vagrant upコマンド一つ打つだけで、192.168.33.10 をブラウザで叩いた際に、
cakephpのアプリが一発で立ち上がるスクリプトを書いています。

※サーバーはビルドインサーバーでなくアパッチをインストールし使用するように作成しています。

## 前提条件
vagrant 1.8.4 〜 1.8.6

virtualbox 

mac ( linux )


## インストール環境
centOS 7.2

php 7.0   or  php5.6

Mysql5.6  or  Mariadb

cakephp 3.2.12


## 備考
provision.sh で sudo を使わず yum から書いているコマンドばかりですが、
sudo で行っているのと同じになります。
これは、Vagrantfileに書かれている、config.vmprovision "shell" がデフォルトでsudo権限で行うためです。

## dev_cake ディレクトリ / cake の version 変更について

git管理で、丸々cakeのディレクトリを持ってきているが、本来、下記を実行している。

①仮想環境でcakephpをインストール
gitで管理するためにホストPCで取得したいため共有フォルダにインストール
$ cd /vagrant/
$ /usr/local/bin/composer.phar create-project --prefer-dist cakephp/app dev_app
dev_appがホストPCに作成される。(シンクされる)

②config/app.phpをgitで管理したいので.gitignoreから/config/app.phpを削除
その後に/config/app.phpもコミットしてる。※ .gitignoreは、デフォで作成されるため

※ .gitignore は /vagrant と /vagrant/dev_app にもあり、ここでは後者を指す
※ app.phpは、のちのちデータベースの定義をする際などでも使うのでgit管理にします。そのため、ignoreから外す

③ライブラリをインストール (vendor,tmp,logsディレクトリ作成)
(gitにあげたdev_appを共有フォルダに事前に配置してあることが前提条件)
/vagrant/dev_app に移動し、下記を実行。
ライブラリをインストールする /usr/local/bin/composer.phar install
これによりvebdorやtemp,logsのフォルダが作成される。

しかし「 /usr/local/bin/composer.phar create-project --prefer-dist cakephp/app dev_app 」を
実行している場合はすでに存在するため、何も起こりません。

ようはgitignoreで、vendorなどをはじいておりますが、
「 /usr/local/bin/composer.phar install 」のコマンドをシェルに書いておくことにより、毎回、vagrant(ゲスト)側だけに、vendorなどが入る仕組みになっております。
※ちなみにこのコマンドは、/vagrant/test_app/composer.json の中身を実行しています。
dev_appは、プログラムなど入っており変化するのでgit管理をし、
変化のないものvendorなどや、logなどあったらコンフリクトをたくさん起こしそうなものは、ignoreではじいています。

## cake 2.x 系の手動インストール 

仮想のcd ドキュメントルート で下記を実行
git clone -b 2.x git://github.com/cakephp/cakephp.git
これで2系の最新版が来る。

allグリーンにするために
手動修正点
1 権限を変更 (実行ユーザーvagrantにする手も可能)
sudo chown -R apache app/tmp
sudo chmod -R 755 app/tmp

2  /etc/httpd/conf/httpd.conf を下記のようにする
<Directory "/var/www/html">
#   AllowOverride None
   AllowOverride All
</Directory>

3 Security.salt及びSecurity.cipherSeedの変更

4 db  /app/Config の.defaultを除く
mv database.php.default database.php

5 db作成し、設定。userは新規でなくてrootも可能
database.php

6 Debug Kit
git clone https://github.com/cakephp/debug_kit.git
app/Pluginにフォルダを配置してDebugKitにリネーム
app/Config/bootstrap.phpに下記を追加(既存であるのでコメントアウトでも良い)
CakePlugin::load('DebugKit');
