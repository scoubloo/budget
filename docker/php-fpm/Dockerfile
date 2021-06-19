FROM php:7.4-fpm

RUN apt-get update && apt-get install -y libicu-dev && apt-get clean
RUN pecl install apcu xdebug
RUN docker-php-ext-enable apcu xdebug
RUN docker-php-ext-install pdo_mysql intl opcache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer --version

RUN apt-get install zip unzip

WORKDIR /var/www
