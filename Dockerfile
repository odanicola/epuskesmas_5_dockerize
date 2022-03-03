#------------- Setup Environment -------------------------------------------------------------

# Pull base image
FROM ubuntu:18.04

# Install common tools 
RUN apt-get update && apt-get install -y wget curl nano htop git unzip bzip2 software-properties-common locales

# Set evn var to enable xterm terminal
ENV TERM=xterm

# Set timezone to UTC to avoid tzdata interactive mode during build
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set working directory
WORKDIR /var/www/html

# Set project to image
ADD . /var/www/html
COPY ./.env /var/www/html/.env

# create log file for initial stream
# RUN touch /var/www/html/storage/logs/lumen.log
# RUN chown -R www-data:www-data /var/www/html/storage/logs

# Set up locales 
# RUN locale-gen 

#------------- Application Specific Stuff ----------------------------------------------------

# Install PHP
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt update
RUN apt-get install -y \
    php7.3-fpm \ 
    php7.3-common \ 
    php7.3-curl \ 
    php7.3-pgsql \ 
    php7.3-mysql \ 
    php7.3-mbstring \ 
    php7.3-json \
    php7.3-xml \
    php7.3-bcmath \
    php7.3-zip \
    php7.3-zmq \
    php7.3-xdebug

# Install NPM and Node.js
# RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
# RUN apt-get install -y nodejs 

#------------- FPM & Nginx configuration ----------------------------------------------------

# Config fpm to use TCP instead of unix socket
ADD resources/www.conf /etc/php/7.3/fpm/pool.d/www.conf
RUN mkdir -p /var/run/php

# Install Nginx
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y nginx

ADD resources/default /etc/nginx/sites-enabled/
ADD resources/nginx.conf /etc/nginx/

#------------- Composer & laravel configuration ----------------------------------------------------

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16 
# RUN composer install

#------------- Supervisor Process Manager ----------------------------------------------------

# Install supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD resources/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#------------- Container Config ---------------------------------------------------------------

# Expose port 8080
EXPOSE 8080

# Set supervisor to manage container processes
ENTRYPOINT ["/usr/bin/supervisord"]