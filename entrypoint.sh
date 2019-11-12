#!/bin/bash

if [ ! -d /var/lib/mysql/mysql ]; then
  MARIADB_NEEDS_INITIAL_SETUP="yes"
  rm -rf /var/lib/mysql/*
  mysql_install_db
fi

/etc/init.d/nginx start
/etc/init.d/mysql start
/etc/init.d/php7.3-fpm start

if [[ "$MARIADB_NEEDS_INITIAL_SETUP" == "yes" ]]; then
  mysql -u root -e "CREATE USER 'project'@'localhost' IDENTIFIED BY 'ibzti18';"
  mysql -u root -e "FLUSH PRIVILEGES;"
fi

cd /usr/share/nginx/html/ibzti18w
dir=$(find . -mindepth 1 -maxdepth 1 -type d)
cd "$dir"

[ ! -L adminer.php ] && ln -s /usr/share/nginx/html/adminer.php adminer.php
[ ! -L webhook.php ] && ln -s /usr/share/nginx/html/webhook.php webhook.php

cd /

tail -f /dev/null
