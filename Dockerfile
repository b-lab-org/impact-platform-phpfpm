FROM alpine:3.5
MAINTAINER "The Impact Bot" <technology@bcorporation.net>

RUN set -ex && \
    apk upgrade --update && \
    apk add --update \
    php5 \
    php5-fpm \
    php5-json \
    php5-mcrypt \
    php5-pgsql \
    php5-pdo_pgsql \
    php5-xdebug \ 
    shadow \
    openssl

RUN apk --no-cache add ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-php5-memcached/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-php5-memcached/releases/download/2.2.0-r0/php5-memcached-2.2.0-r0.apk && \
    apk add --allow-untrusted --no-cache ./php5-memcached-2.2.0-r0.apk && \
    rm php5-memcached-2.2.0-r0.apk && \
    rm -rf /var/cache/apk/*

RUN groupadd www-data && \
    useradd -M -u 1000 -o www-data 

RUN sed -i 's|^;date.timezone =.*|date.timezone = America/New_York|' /etc/php5/php.ini && \
    sed -i 's|^display_errors =.*|display_errors = stderr|' /etc/php5/php.ini && \
    sed -i 's|^upload_max_filesize =.*|upload_max_filesize = 25M|' /etc/php5/php.ini && \
    sed -i 's|^post_max_size =.*|post_max_size = 25M|' /etc/php5/php.ini && \
    sed -i 's|^;opcache.enable=.*|opcache.enable=1|' /etc/php5/php.ini
    
RUN sed -i 's|^listen =.*|listen = 9000|' /etc/php5/php-fpm.conf && \
    sed -i 's|^user =.*|user = www-data|' /etc/php5/php-fpm.conf && \
    sed -i 's|^group =.*|group = www-data|' /etc/php5/php-fpm.conf && \
    sed -i 's|^error_log =.*|error_log = /data/www/storage/logs/php-fpm.log|' /etc/php5/php-fpm.conf && \
    sed -i 's|^;clear_env =.*|clear_env = no|' /etc/php5/php-fpm.conf

RUN mkdir -p /data/www/storage/logs
# RUN php5enmod mcrypt

# igbinary for memcached
#RUN git clone https://github.com/phadej/igbinary.git && \
#    cd igbinary && \
#    phpize && \
#    ./configure CFLAGS="-O2 -g" --enable-igbinary && \
#    make && \
#    make install && \
#    cd .. && \
#    rm -fr igbinary && \
#    echo "extension=igbinary.so" >> /etc/php5/mods-available/igbinary.ini && \
#    echo "igbinary.compact_strings=Off" >> /etc/php5/mods-available/igbinary.ini && \
#    php5enmod igbinary

#RUN usermod -u 1000 www-data
EXPOSE 9000

ENTRYPOINT ["/usr/bin/php-fpm", "-F"]
