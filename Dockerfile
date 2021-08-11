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
    wget \
    unzip \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && apt-get --purge autoremove -y

RUN apt install -y lsb-release apt-transport-https ca-certificates wget && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# PHP 8
RUN apt update && \
    apt install -y \
    php8.0 \
    php8.0-fpm \
    php8.0-dev \
    php8.0-cli \
    php8.0-mbstring \
    php8.0-xml \
    php8.0-sqlite3 \
    php8.0-xdebug \
    php8.0-zip


# NODE JS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs -qq

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Install FileGator
RUN git clone https://github.com/filegator/filegator.git && \
    cd filegator && \
    git checkout v8 && \
    chmod -R 777 private/ && \
    chmod -R 777 repository/ && \
    composer install && \
    npm install && \
    npm run build

# Upload demo files
COPY demorepo /var/www/html/demorepo/
COPY configuration.php /var/www/html/filegator/
COPY users.json /var/www/html/filegator/private/

# Fix permissions so that demo is read-only
RUN chmod -R 655 /var/www/html/demorepo/ && \
    chmod 655 /var/www/html/filegator/private/users.json

EXPOSE 8080

RUN adduser rouser

RUN php --version
RUN cd /var/www/html/filegator/ && \
    XDEBUG_MODE=coverage vendor/bin/phpunit


CMD ["su", "-", "rouser", "-c", "cd /var/www/html/filegator/dist/ && php -S 0.0.0.0:8080"]

