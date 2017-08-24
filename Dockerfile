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
    opcache \
    zip && \

    pecl install \
    xdebug \
    memcached-2.2.0 && \
    docker-php-ext-enable xdebug memcached opcache && \

    # permissions
    usermod -u 1000 www-data && \

    # phantomjs prebuilt binary
    curl -Ls https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz \
       | tar xz -C / && \

    # cleanup
    apk del \
    autoconf \
    g++ \
    make \
    cyrus-sasl-dev \
    shadow && \
    rm -rf /var/cache/apk/* && \
    docker-php-source delete

ADD php.ini $PHP_INI_DIR/conf.d/impact.ini

EXPOSE 9000
CMD ["php-fpm"]
