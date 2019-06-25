FROM php:7.2.7-fpm-alpine

RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    echo /etc/apk/respositories && \
    apk update && \
    apk add --no-cache bash curl supervisor nginx && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor && \
    curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN printf "\n%s\n%s" "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update add imagemagick-dev@edge imagemagick@edge && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS libtool && \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" && \
    pecl install imagick-3.4.3 && \
    docker-php-ext-enable imagick
    
RUN sed -i -e "s/^;clear_env = no$/clear_env = no/" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 50/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 10/g" /usr/local/etc/php-fpm.d/www.conf
   

ADD config/supervisord.conf /etc/supervisord.conf
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD script/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80
