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
    php5 \
    php5-calendar \
    php5-cli \
    php5-ctype \
    php5-curl \
    php5-dom \
    php5-exif \
    # php5-fileinfo \
    php5-fpm \
    php5-ftp \
    php5-gd \
    php5-gettext \
    # php5-gmagick \
    php5-iconv \
    php5-intl \
    php5-json \
    # php5-mbstring \
    php5-mcrypt \
    php5-mysqli \
    php5-opcache \
    php5-pdo \
    php5-pdo_mysql \
    php5-phar \
    php5-posix \
    # php5-session \
    php5-shmop \
    # php5-simplexml \
    php5-sockets \
    # php5-sodium \
    php5-sysvmsg \
    php5-sysvsem \
    php5-sysvshm \
    # php5-tokenizer \
    php5-wddx \
    php5-xml \
    php5-xmlreader \
    # php5-xmlwriter \
    php5-xsl \
    php5-zip \
    supervisor

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
COPY config/php/php-pool.conf /etc/php5/php-fpm.d/zzz_custom_pool.conf
COPY config/php/php.ini /etc/php5/conf.d/zzz_custom_phpini.ini
COPY config/mailhog/mailhog.ini /etc/php5/conf.d/mailhog.ini

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