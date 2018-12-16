# Start with Alpine as it's very minimal.
FROM alpine:3.8

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A configurable WordPress container based on Chassis <https://chassis.io>"

RUN apk --no-cache add bash \
    fcgi \
    nginx \
    openrc \
    php7 \
    php7-cli \
    php7-fpm \
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
