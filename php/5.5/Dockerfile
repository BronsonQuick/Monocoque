# Start with Alpine as it's very minimal.
FROM alpine:2.7

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A lightweight and functional WordPress, Nginx, MySQL and MailHog container"

RUN apk --update --virtual add bash \
    curl \
    fcgi \
    imagemagick \
    nginx \
    php \
    php-calendar \
    php-cli \
    php-ctype \
    php-curl \
    php-dom \
    php-exif \
    # php-fileinfo \
    php-fpm \
    php-ftp \
    php-gd \
    php-gettext \
    # php-gmagick \
    php-iconv \
    php-intl \
    php-json \
    # php-mbstring \
    php-mcrypt \
    php-mysqli \
    php-opcache \
    php-pdo \
    php-pdo_mysql \
    php-phar \
    php-posix \
    # php-session \
    php-shmop \
    # php-simplexml \
    php-sockets \
    # php-sodium \
    php-sysvmsg \
    php-sysvsem \
    php-sysvshm \
    # php-tokenizer \
    php-wddx \
    php-xml \
    php-xmlreader \
    # php-xmlwriter \
    php-xsl \
    php-zip

# RUN go get github.com/mailhog/mhsendmail && cp /root/go/bin/mhsendmail /usr/bin/mhsendmail && apk del build-dependencies

# Setup nginx.
RUN adduser -D -g 'www' www
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /var/www/html
RUN mkdir -p /var/lib/nginx
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /var/www/html

COPY config/php/php-pool.conf /etc/php/php-fpm.d/zzz_custom_pool.conf
COPY config/php/php.ini /etc/php/conf.d/zzz_custom_phpini.ini
COPY config/mailhog/mailhog.ini /etc/php/conf.d/mailhog.ini

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o latest.tar.gz -SL https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz -C /var/www/html/ \
	&& rm latest.tar.gz \
	&& mv /var/www/html/wordpress/* /var/www/html/ \
	&& rmdir /var/www/html/wordpress/ \
	&& chown -R nobody.nobody /var/www/html

# Copy the files we need
COPY phpinfo.php /var/www/html/phpinfo.php
COPY wp-config.php /var/www/html/wp-config.php
COPY local-config-db.php /var/www/html/local-config-db.php
COPY local-config.php /var/www/html/local-config.php

# Install WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Configure supervisord
COPY config/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "sh", "/entrypoint.sh" ]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# Expose the default http and https ports.
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]s
