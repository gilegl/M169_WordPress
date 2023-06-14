# Verwenden des offiziellen WordPress-Basisimages
FROM wordpress:latest

# Installiere zusätzliche Abhängigkeiten und Aktualisiere das System
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip

# Apache-Mod-Rewrite-Modul aktivieren
RUN a2enmod rewrite

# Setze die PHP-Einstellungen für WordPress
RUN sed -i 's/memory_limit = .*/memory_limit = 256M/' /usr/local/etc/php/conf.d/docker-php-memlimit.ini
RUN sed -i 's/upload_max_filesize = .*/upload_max_filesize = 64M/' /usr/local/etc/php/conf.d/docker-php-uploadlimit.ini
RUN sed -i 's/post_max_size = .*/post_max_size = 64M/' /usr/local/etc/php/conf.d/docker-php-postlimit.ini

# Setze den Apache-Port auf 80
EXPOSE 80

# Starte den Apache-Webserver beim Start des Containers
CMD ["apache2-foreground"]

