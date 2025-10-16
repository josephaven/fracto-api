# ------------------------------------------------------------
# FRACTO API - Dockerfile para despliegue en Render
# ------------------------------------------------------------

FROM php:8.3-apache

# Dependencias PHP + Postgres
RUN apt-get update && apt-get install -y \
    git unzip zip libpq-dev libzip-dev \
 && docker-php-ext-install pdo pdo_pgsql zip \
 && a2enmod rewrite

# Servir Laravel desde /public y habilitar .htaccess
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!Directory /var/www/!Directory ${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf \
    && sed -ri -e 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf \
    && a2enmod rewrite

# Copia de código
COPY . /var/www/html
WORKDIR /var/www/html

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Migraciones tolerantes y arranque
CMD php artisan migrate --force --no-interaction || true && apache2-foreground

EXPOSE 80
