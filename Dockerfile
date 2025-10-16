# ------------------------------------------------------------
# FRACTO API - Dockerfile para despliegue en Render
# ------------------------------------------------------------

# Imagen base: PHP 8.3 con Apache
FROM php:8.3-apache

# Instala dependencias necesarias para Laravel y PostgreSQL
RUN apt-get update && apt-get install -y \
    git unzip zip libpq-dev libzip-dev \
 && docker-php-ext-install pdo pdo_pgsql zip \
 && a2enmod rewrite

# Copia todos los archivos del proyecto al contenedor
COPY . /var/www/html

# Define el directorio de trabajo
WORKDIR /var/www/html

# Instala Composer (copiado desde imagen oficial)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instala dependencias de Laravel sin las de desarrollo y optimiza
RUN composer install --no-dev --optimize-autoloader

# Da permisos de escritura a storage y cache (necesarios en Laravel)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Genera APP_KEY y ejecuta migraciones automáticamente al arrancar el contenedor
# (si las variables de entorno están configuradas)
CMD php artisan key:generate --force && \
    php artisan migrate --force --no-interaction && \
    apache2-foreground

# Expone el puerto HTTP
EXPOSE 80
