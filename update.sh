#!/bin/bash

cd /usr/share/nginx/html
git reset --hard
git clean -df
git pull origin master

if [ -f "./.webtechdeploy/postinstall.sh" ]; then
  bash ./.webtechdeploy/postinstall.sh
fi

if [ -f "./.webtechdeploy/nginx.conf" ]; then
  cp ./.webtechdeploy/nginx.conf /etc/nginx/sites-available/default
  /etc/init.d/nginx restart
fi

rm -rf ./.webtechdeploy

mkdir -p "~admin"
cd "~admin"

[ ! -L adminer.php ] && ln -s /opt/webtechdeploy/adminer.php adminer.php
[ ! -L webhook.php ] && ln -s /opt/webtechdeploy/webhook.php webhook.php

cd /
