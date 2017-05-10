FROM php:5.6-fpm-alpine
MAINTAINER "The Impact Bot" <technology@bcorporation.net>

RUN set -xe; \
    echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk add --no-cache \
    libmemcached-dev \
    libmcrypt-dev \
    postgresql-dev \
    autoconf \
    g++ \
    make \
    cyrus-sasl-dev \
    shadow && \

    # php extensions
    docker-php-ext-install \
    json \
    mcrypt \
    pdo \
    pdo_pgsql \
    zip && \
    pecl install \
    xdebug \
    memcached-2.2.0 && \
    docker-php-ext-enable xdebug memcached && \

    # permissions
    usermod -u 1000 www-data && \

    # cleanup
    apk del \
    autoconf \
    g++ \
    make \
    cyrus-sasl-dev \
    shadow && \
    rm -rf /var/cache/apk/*

ADD php.ini $PHP_INI_DIR/conf.d/impact.ini

EXPOSE 9000
CMD ["php-fpm"]
