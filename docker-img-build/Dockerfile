# FROM php:7.1.7-fpm-alpine
# RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
#   && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
#   libjpeg-turbo-dev libpng-dev libxml2-dev msmtp postgresql-dev \
#   && docker-php-source extract \
#   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
#                                    --with-png-dir=/usr/include/ \
#                                    --with-jpeg-dir=/usr/include/ \
#   && docker-php-ext-install gd mcrypt mysqli pdo pdo_mysql pdo_pgsql pgsql zip ftp opcache \
#   && pecl install mongodb redis xdebug \
#   && docker-php-ext-enable mongodb \
#   && docker-php-ext-enable redis \
#   && docker-php-ext-enable xdebug \
#   && docker-php-source delete \
#   && apk del .build-deps \
#   # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
#   && apk --no-cache add curl git openssh \
#   && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

FROM php:7.0.23-fpm
# extensions: mysqli pdo-mysql
# RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
#     && docker-php-ext-configure mysqli --with-mysqli=mysqlnd 
# RUN  docker-php-ext-install  pdo_mysql   mysqli

# # extensions: gd 
# RUN apt-get update && apt-get install -y \
#          libfreetype6-dev \
#          libjpeg62-turbo-dev \
#          libmcrypt-dev \
#          libpng12-dev \
#      && docker-php-ext-install -j$(nproc) iconv mcrypt \
#      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#      && docker-php-ext-install -j$(nproc) gd

# # extensions: zip xml
# RUN apt-get update && apt-get install -y \
#         libzip-dev \
#         libxml2-dev \ 
#     && docker-php-source extract \
#     && cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 \
#     && docker-php-ext-install zlib zip xml \
#     && docker-php-source delete

# extensions:  mongodb 
RUN apt-get update && apt-get install -y \
        libssl-dev \
     && pecl install mongodb \
     && docker-php-ext-enable mongodb

# extensions: redis xdebug
RUN pecl install redis-3.1.4 \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable redis xdebug


# extensions: swoole
 RUN pecl install swoole-1.9.21 \
      && docker-php-ext-enable swoole