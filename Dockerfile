FROM debian:stretch
MAINTAINER Sven Gehring <cbrxde@gmail.com>

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
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
    apt-transport-https && \
  wget https://packages.sury.org/php/apt.gpg && \
  apt-key add apt.gpg && \
  rm apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list && \
  apt-get update && \
  apt-get install -y \
    sudo \
    php7.3 \
    php7.3-cli \
    php7.3-common \
    php7.3-fpm \
    php7.3-curl \
    php7.3-mysql \
    php7.3-xml \
    php7.3-mbstring \
    nginx \
    mariadb-common \
    mariadb-server \
    mariadb-client && \
  mkdir /opt/webtechdeploy

WORKDIR /opt/webtechdeploy
RUN curl -L https://github.com/vrana/adminer/releases/download/v4.7.5/adminer-4.7.5-en.php -o adminer.php
COPY webhook.php /opt/webtechdeploy

COPY nginx.conf /etc/nginx/sites-available/default
COPY entrypoint.sh /usr/sbin/
COPY update.sh /usr/sbin/

WORKDIR /usr/share/nginx/html
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir=/usr/bin --filename=composer && \
  php -r "unlink('composer-setup.php');" && \
  chmod +x /usr/sbin/update.sh && \
  chmod +x /usr/sbin/entrypoint.sh && \
  chown -R www-data:www-data /usr/share/nginx/html && \
  rm /usr/share/nginx/html/index.html && \
  echo "www-data ALL = NOPASSWD : /usr/sbin/update.sh" >> /etc/sudoers

EXPOSE 80

CMD ["/usr/sbin/entrypoint.sh"]
