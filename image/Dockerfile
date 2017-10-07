FROM php:7.1-fpm-alpine

ENV WEBTREES_VERSION 1.7.9

RUN set -e \
    && apk add --no-cache \
       supervisor \
       nginx \
       # GD
       freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .build-deps \
       # For pulling archive over https
       ca-certificates \
       openssl \
       # For GD (creating thumbnails inside webtrees)
       libpng-dev libjpeg-turbo-dev freetype-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install \
       gd \
       pdo \
       mysqli \
       pdo_mysql \
    && wget https://github.com/fisharebest/webtrees/archive/$WEBTREES_VERSION.tar.gz \
    && tar -xzf $WEBTREES_VERSION.tar.gz --strip-components=1 \
    && rm $WEBTREES_VERSION.tar.gz \
    && apk del .build-deps \
    && cp -r /var/www/html/data /var/www/html/data.bak \
    && chown -R www-data /var/www/html \
    && chmod -R g-w /var/www/html*

COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/
COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /var/www/html/data

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
