FROM debian:stretch
MAINTAINER Sven Gehring <cbrxde@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y \
  git \
  nano \
  composer \
  zip \
  unzip \
  wget \
  curl \
  procps \
  gnupg2 \
  net-tools \
  ca-certificates \
  lsb-release \
  apt-transport-https

RUN wget https://packages.sury.org/php/apt.gpg && \
  apt-key add apt.gpg && \
  rm apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list && \
  apt-get update && \
  apt-get install -y \
    php7.3 \
    php7.3-cli \
    php7.3-common \
    php7.3-fpm \
    php7.3-curl \
    php7.3-mysql

RUN apt-get install -y nginx

RUN apt-get install -y \
  mariadb-common \
  mariadb-server \
  mariadb-client

RUN mkdir /usr/share/nginx/html/~admin
WORKDIR /usr/share/nginx/html/~admin

RUN curl https://github.com/vrana/adminer/releases/download/v4.7.5/adminer-4.7.5-en.php -o adminer.php

COPY nginx.conf /etc/nginx/sites-available/default
COPY webhook.php /usr/share/nginx/html/~admin
COPY entrypoint.sh /usr/sbin/
COPY update.sh /usr/sbin/

RUN chmod +x /usr/sbin/update.sh
RUN chmod +x /usr/sbin/entrypoint.sh
RUN chown -R www-data:www-data /usr/share/nginx/html
RUN rm /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["/usr/sbin/entrypoint.sh"]
