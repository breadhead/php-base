# php-base
Base image for PHP app

## Usage

Create the following `Dockerfile` in your project dir:

```
FROM breadgheadhub/php-base

ENV APP_ENV=prod
ENV APP_DEBUG=0

COPY . /var/www/html/

RUN composer install --no-dev

CMD ["/start.sh"]
```

Great! App will be start from `public/index.php` on 80 port in container.
