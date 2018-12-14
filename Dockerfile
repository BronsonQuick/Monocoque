# Start with Alpine as it's very minimal.
FROM alpine:3.6

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A configurable WordPress container based on Chassis <https://chassis.io>"

RUN apk --no-cache add nginx \
    bash

# Make a directory for nginx.
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/sites-enabled

# Copy the default Nginx configuration file.
COPY .config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .config/nginx/site.nginx.conf /etc/nginx/sites-available/localhost
RUN ln -fs /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
COPY index.html /var/www/html/index.html

# Make the nginx logs available for Docker logs.
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose the default http and https ports.
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
