# Start with Alpine as it's very minimal.
FROM alpine:3.8

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A configurable WordPress container based on Chassis <https://chassis.io>"

RUN apk --no-cache add bash \
    curl \
    fcgi \
    imagemagick \
    mariadb \
    mariadb-client \
    nginx \
    openrc \
    php7 \
    php7-calendar \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-gettext \
    php7-gmagick \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqli \
    php7-opcache \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-posix \
    php7-session \
    php7-shmop \
    php7-simplexml \
    php7-sockets \
    php7-sodium \
    php7-sysvmsg \
    php7-sysvsem \
    php7-sysvshm \
    php7-tokenizer \
    php7-wddx \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-xsl \
    php7-zip \
    supervisor

# Make a directory for nginx.
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /var/www/html

RUN adduser -D -g 'www' www
RUN chown -R www:www /var/www/html

# Copy the default Nginx configuration file.
COPY .config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .config/nginx/site.nginx.conf /etc/nginx/sites-available/localhost
RUN ln -fs /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
COPY phpinfo.php /var/www/html/phpinfo.php
COPY .config/php/php-pool.conf /etc/php7/php-fpm.d/zzz_custom_pool.conf
COPY .config/php/php.ini /etc/php7/conf.d/zzz_custom_phpini.ini

# Configure supervisord
COPY .config/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make the nginx logs available for Docker logs.
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose the default http and https ports.
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
