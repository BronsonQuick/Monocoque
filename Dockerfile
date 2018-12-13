# Start with Alpine as it's very minimal.
FROM alpine:3.6

# Add in details so you can blame me when things break.
LABEL Maintainer="Bronson Quick <bronson@bronsonquick.com.au>" \
      Description="A configurable WordPress container based on Chassis <https://chassis.io>"

RUN apk --no-cache add nginx

# Make a directory for nginx.
RUN mkdir -p /run/nginx

# Make the nginx logs available for Docker logs.
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.lo

# Expose the default http and https ports.
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
