# Impact Platform: PHP-FPM
[Docker](https://www.docker.com/) container for [PHP-FPM](http://php-fpm.org/).

## Overview
Use with the [data container](https://github.com/b-lab-org/impact-platform-data) and [memcached container](https://github.com/b-lab-org/impact-platform-memcached).

## Docker-Compose Usage
```
phpfpm:
    image: impactbot/impact-platform-phpfpm
    volumes_from:
        - data
    ports:
        - "9000:9000"
    links:
        - memcached
```
