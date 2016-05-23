FROM debian:jessie
MAINTAINER "The Impact Bot" <technology@bcorporation.net>

RUN apt-get update -y && \
    apt-get install -y \
    git \
    php5 \
    php5-fpm \
    php5-curl \
    php5-gd \
    php5-geoip \
    php5-imagick \
    php5-imap \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-mongo \
    php5-mysqlnd \
    php5-pgsql \
    php5-redis \
    php5-sqlite \
    php5-xdebug \
    php5-memcached \
    php5-dev

RUN sed -i "s/;date.timezone =.*/date.timezone = GMT/" /etc/php5/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini && \
    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php5/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php5/fpm/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=1/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i '/^listen = /clisten = 9000' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^;env\[TEMP\] = .*/aenv[MYSQL_PORT_3306_TCP_ADDR] = $MYSQL_PORT_3306_TCP_ADDR' /etc/php5/fpm/pool.d/www.conf

RUN php5enmod mcrypt

# igbinary for memcached
RUN git clone https://github.com/phadej/igbinary.git && \
    cd igbinary && \
    phpize && \
    ./configure CFLAGS="-O2 -g" --enable-igbinary && \
    make && \
    make install && \
    cd .. && \
    rm -fr igbinary && \
    echo "extension=igbinary.so" >> /etc/php5/mods-available/igbinary.ini && \
    echo "igbinary.compact_strings=Off" >> /etc/php5/mods-available/igbinary.ini && \
    php5enmod igbinary

RUN usermod -u 1000 www-data
ADD php.ini /etc/php5/fpm/conf.d/40-custom.ini

EXPOSE 9000

ENTRYPOINT ["/usr/sbin/php5-fpm", "-F"]
