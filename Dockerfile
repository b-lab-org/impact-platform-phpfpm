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

# TODO postgresql client - if replacing artisan/codeception
# TODO igbinary?

ADD php.ini $PHP_INI_DIR/conf.d/impact.ini

EXPOSE 9000
CMD ["php-fpm"]
