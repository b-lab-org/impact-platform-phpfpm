FROM php:5.6-fpm-alpine
MAINTAINER "The Impact Bot" <technology@bcorporation.net>

RUN set -xe; \
    apk add --no-cache \
    libmemcached-dev \
    libmcrypt-dev \
    postgresql-dev \
    autoconf \
    g++ \
    make \
    cyrus-sasl-dev

RUN docker-php-ext-install \
    json \
    mcrypt \
    pdo \
    pdo_pgsql

RUN pecl install \
    xdebug \
    memcached-2.2.0 \
    && docker-php-ext-enable xdebug memcached

ADD php.ini $PHP_INI_DIR/conf.d/impact.ini
RUN usermod -u 1000 www-data

EXPOSE 9000
CMD ["php-fpm"]
