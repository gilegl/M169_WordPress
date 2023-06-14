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

# Plugin WP-Forms herunterladen und installieren
RUN wp plugin install wpforms --activate --allow-root

# Plugin "WP Maintenance Mode" herunterladen und installieren
RUN wp plugin install wp-maintenance-mode --activate --allow-root

# Setze den Apache-Port auf 80
EXPOSE 80

# Starte den Apache-Webserver beim Start des Containers
CMD ["apache2-foreground"]
