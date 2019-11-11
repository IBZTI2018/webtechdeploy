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

COPY adminer.php /usr/share/nginx/html
COPY webhook.php /usr/share/nginx/html
COPY entrypoint.sh /usr/sbin/
COPY nginx.conf /etc/nginx/sites-available/default

RUN chmod +x /usr/sbin/entrypoint.sh
RUN chown -R www-data:www-data /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/project
RUN rm /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["/usr/sbin/entrypoint.sh"]
