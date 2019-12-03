#!/bin/bash

cd /usr/share/nginx/html
git reset --hard
git clean -df
git pull origin master
cd /
