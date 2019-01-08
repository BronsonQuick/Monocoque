# Monocoque

This is a base Docker WordPress container based on Alpine Linux that contains Dockerfile's for PHP 5.5 - 7.2. Containers should be setup using [Monocoque CLI](https://github.com/BronsonQuick/Monocoque-CLI). Monocoque CLI generates `docker-compose.yml` files for you based on user input.

## Image Contains

- Nginx
- PHP Fpm
- WP-CLI
- Mailhog

## PHP Modules
- Calendar
- CLI
- Ctype
- Curl
- Dom
- Exif
- Fileinfo
- Ftp
- GD
- Gettext
- Gmagick
- Iconv
- Intl
- Json
- Mbstring
- Mcrypt
- Mysqli
- Opcache
- PDO
- PDO MySQL
- Phar
- Posix
- Session
- Shmop
- SimpleXML
- Sockets
- Sodium
- Sysvmsg
- Sysvsem
- Sysvshm
- Tokenizer
- Wddx
- XML
- XMLreader
- XMLwriter
- XSL
- Zip

## PHP Info

You can browse to [http://localhost/phpinfo.php](http://localhost/phpinfo.php) to view PHP configuration details.

## Configuration Details

`local-config.php` - This file contains some sensible defaults for WordPress. It shouldn't be shipped to production servers.

`local-config-db.php` - contains your WordPress database constants which are read from environmental variables that are stored in `config.env`.

`config.env` - This file contains WordPress database constants, MySQL and Nginx variables. Eventually this file might contain other configuation details.

## MailHog

MailHog is automatically setup and configured for you so that it catches WordPress emails. Browse to http://localhost:8025 to view it.
