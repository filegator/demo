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
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && apt-get --purge autoremove -y

# NODE JS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs -qq

# PHP
RUN apt-get install -y \
    php7.3-dev \
    php7.3-cli \
    php7.3-mbstring \
    php7.3-zip

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Install FileGator
RUN git clone https://github.com/filegator/filegator.git && \
    cd filegator && \
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

CMD ["su", "-", "rouser", "-c", "cd /var/www/html/filegator/dist/ && php -S 0.0.0.0:8080"]

