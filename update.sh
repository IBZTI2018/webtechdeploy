#!/bin/bash

cd /usr/share/nginx/html/ibzti18w
dir=$(find . -mindepth 1 -maxdepth 1 -type d)
cd "$dir"
cd ./project

git reset --hard
git clean -df
git pull origin master

cd /
