FROM filegator/filegator

# Copy demo files
COPY demorepo /var/www/demorepo/
COPY configuration.php /var/www/filegator/
COPY users.json /var/www/filegator/private/

# Fix permissions so that demo is read-only
USER root
RUN chmod -R 655 /var/www/demorepo/ && \
    chmod 655 /var/www/filegator/private/users.json

USER www-data

CMD ["apache2-foreground"]

