FROM debian:buster

RUN apt update && apt -y install \
    wget \
    curl \
    bash \
    php \
    php-mysql \
    php-fpm
    
RUN apt upgrade -y


RUN rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp


COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

RUN mkdir -p /run/php

COPY ./tools/create_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_wordpress.sh
ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]

WORKDIR /var/www/html


EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "-F"]

