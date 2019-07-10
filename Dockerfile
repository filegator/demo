FROM debian:buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    locales \
    software-properties-common \
    build-essential \
    curl \
    git \
    unzip \
    mcrypt \
    wget \
    openssl \
    autoconf \
    openssh-client \
    g++ \
    make \
    libssl-dev \
    libcurl4-openssl-dev \
    libsasl2-dev \
    imagemagick \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && apt-get --purge autoremove -y

# NODE JS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs -qq

# PHP
RUN apt-get install -y php-pear \
    php7.3-dev \
    php7.3-cli \
    php7.3-fpm \
    php7.3-apcu \
    php-amqp \
    php7.3-bcmath \
    php7.3-bz2 \
    php7.3-calendar \
    php7.3-common \
    php7.3-ctype \
    php7.3-curl \
    php7.3-dba \
    php7.3-dom \
    php7.3-embed \
    php7.3-enchant \
    php7.3-exif \
    php7.3-ftp \
    php7.3-gd \
    php7.3-gettext \
    php7.3-gmp \
    php7.3-iconv \
    php7.3-imagick \
    php7.3-imap \
    php7.3-intl \
    php7.3-json \
    php7.3-ldap \
    php7.3-mbstring \
    php-memcache \
    php7.3-memcached \
    php7.3-mongodb \
    php7.3-mysqli \
    php7.3-mysqlnd \
    php7.3-odbc \
    php7.3-opcache \
    php7.3-pdo \
    php7.3-pgsql \
    php7.3-phar \
    php7.3-phpdbg \
    php7.3-posix \
    php7.3-pspell \
    php7.3-redis \
    php7.3-shmop \
    php7.3-snmp \
    php7.3-soap \
    php7.3-sockets \
    php7.3-sqlite3 \
    php7.3-sysvmsg \
    php7.3-sysvsem \
    php7.3-sysvshm \
    php7.3-tidy \
    php7.3-tokenizer \
    php7.3-wddx \
    php7.3-xdebug \
    php7.3-xml \
    php7.3-xmlreader \
    php7.3-xmlrpc \
    php7.3-xmlwriter \
    php7.3-xsl \
    php7.3-zip

# Time Zone
RUN echo "date.timezone = UTC" > /etc/php/7.3/cli/conf.d/date_timezone.ini && \
    echo "date.timezone = UTC" > /etc/php/7.3/fpm/conf.d/date_timezone.ini

# Apache2
RUN apt-get install -y apache2 libapache2-mod-php7.3 && \
    a2ensite default-ssl

VOLUME /root/composer

# Environmental Variables
ENV COMPOSER_HOME /root/composer

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Goto temporary directory.
WORKDIR /var/www/html

RUN git clone https://github.com/filegator/filegator.git && \
    cd filegator && \
    cp configuration_sample.php configuration.php && \
    chmod -R 777 private/ && \
    chmod -R 777 repository/ && \
    composer install && \
    npm install && \
    npm run build

# Upload demo
COPY demorepo /var/www/html/demorepo/
COPY configuration.php /var/www/html/filegator/
COPY users.json /var/www/html/filegator/private/

RUN chmod -R 755 /var/www/html/demorepo/ && \
    chmod 755 /var/www/html/filegator/private/users.json

## Configure Apache webroot
RUN sed -i -e 's/html/html\/filegator\/dist/g' /etc/apache2/sites-enabled/000-default.conf && \
    sed -i -e 's/html/html\/filegator\/dist/g' /etc/apache2/sites-enabled/default-ssl.conf

EXPOSE 80 443

CMD apachectl -D FOREGROUND

