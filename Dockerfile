FROM ubuntu:20.04

RUN apt update && apt-get install -y \
    openssl \
    git \
    unzip \
    vim \
    curl

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install postgresql-12 -y
#RUN update-rc.d postgresql enable
USER postgres
RUN  /etc/init.d/postgresql start &&\
    psql --command "CREATE USER user PASSWORD 'password';" &&\
    psql --command "CREATE DATABASE db OWNER user;"

USER root
RUN apt install apache2 -y
RUN a2enmod rewrite
#RUN apt install php7.4 libapache2-mod-php7.4 openssl php-imagick php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-pgsql php-ssh2 php7.4-xml php7.4-zip unzip
RUN apt install php7.4 php-pgsql php-mbstring php-intl php-xml -y
RUN apt install php-gd php-zip php-curl -y
RUN apt install php-ldap -y
RUN ls

# Installation de composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Installation de symfony.
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Installation de nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install nodejs
RUN npm install -g yarn

RUN service postgresql start
#RUN dsfsdf
WORKDIR /var/www/html
CMD ["apachectl", "-D", "FOREGROUND"]
