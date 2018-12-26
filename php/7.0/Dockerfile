# Start with Alpine as it's very minimal.
FROM alpine:3.5

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A lightweight and functional WordPress, Nginx, MySQL and MailHog container"

RUN apk --no-cache add --virtual build-dependencies \
    git \
    go \
    libc-dev

# Configure Go
ENV GOPATH /root/go

RUN apk --no-cache --virtual add bash \
    curl \
    fcgi \
    imagemagick \
    php7 \
    php7-calendar \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-gettext \
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
    php7-sockets \
    php7-sysvmsg \
    php7-sysvsem \
    php7-sysvshm \
    php7-wddx \
    php7-xml \
    php7-xmlreader \
    php7-xsl \
    php7-zip \
    supervisor

# Symlink php to php7 for PHP CLI
RUN ln -s /usr/bin/php7 /usr/bin/php

RUN go get github.com/mailhog/mhsendmail && cp /root/go/bin/mhsendmail /usr/bin/mhsendmail && apk del build-dependencies

# Make a directory for nginx.
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /var/www/html

RUN chown -R nobody.nobody /var/www

# Copy the default Nginx configuration file.
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/site.nginx.conf /etc/nginx/sites-available/localhost
RUN ln -fs /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
COPY config/php/php-pool.conf /etc/php7/php-fpm.d/zzz_custom_pool.conf
COPY config/php/php.ini /etc/php7/conf.d/zzz_custom_phpini.ini
COPY config/mailhog/mailhog.ini /etc/php7/conf.d/mailhog.ini

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
EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
