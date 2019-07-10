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

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

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
COPY start.sh /var/www/html/filegator/dist/

# Fix permissions
RUN chmod -R 755 /var/www/html/demorepo/ && \
    chmod 755 /var/www/html/filegator/private/users.json && \
    chmod 777 /var/www/html/filegator/dist/start.sh

EXPOSE 8080

# User which will run start.sh
RUN adduser user

WORKDIR /var/www/html/filegator/dist/

CMD ["su", "-", "user", "-c", "cd /var/www/html/filegator/dist/ && ./start.sh"]

