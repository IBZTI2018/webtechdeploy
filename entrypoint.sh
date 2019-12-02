#!/bin/bash

echo "$HOOK_SECRET" > /etc/hook_secret

echo "display_errors = on" >> /etc/php/7.3/fpm/php.ini

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
  mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'project'@'localhost' WITH GRANT OPTION;"
  mysql -u root -e "FLUSH PRIVILEGES;"
fi

cd /usr/share/nginx/html/ibzti18w
dir=$(find . -mindepth 1 -maxdepth 1 -type d)
cd "$dir"

chmod -R 777 ./project

[ ! -L adminer.php ] && ln -s /usr/share/nginx/html/adminer.php adminer.php
[ ! -L webhook.php ] && ln -s /usr/share/nginx/html/webhook.php webhook.php

cd /

# dynamically set up nginx index rewrite
nginxconfig=/etc/nginx/sites-available/default
sed -i "s/^.*#dynamicrewrite$/    try_files \$uri \$uri\/ \/ibzti18w\/$dir\/index.php?\$query_string; #dynamicrewrite/" $nginxconfig


tail -f /dev/null
