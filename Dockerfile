FROM php:7.2.8-fpm-alpine

ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini

RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    echo /etc/apk/respositories && \
    apk update && \
    apk add --no-cache bash curl supervisor nginx && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor && \
    curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN sed -i -e "s/^;clear_env = no$/clear_env = no/" /usr/local/etc/php-fpm.d/www.conf

ADD config/supervisord.conf /etc/supervisord.conf
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD script/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80
