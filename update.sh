#!/bin/bash

cd /usr/share/nginx/html
git reset --hard
git clean -df
git pull origin master

mkdir -p "~admin"
cd "~admin"

[ ! -L adminer.php ] && ln -s /opt/webtechdeploy/adminer.php adminer.php
[ ! -L webhook.php ] && ln -s /opt/webtechdeploy/webhook.php/ webhook.php

cd /
