# docker/php/Dockerfile
FROM php:8.2-fpm

# Arguments (opcional para UID/GID)
ARG WWWGROUP=1000
ARG WWWUID=1000

# Instala dependências do sistema e extensões PHP necessárias para Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libicu-dev \
    libxml2-dev \
    zlib1g-dev \
    sendmail \
    ca-certificates \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install -j$(nproc) \
       pdo_mysql \
       mbstring \
       exif \
       pcntl \
       bcmath \
       gd \
       zip \
       intl \
    && pecl channel-update pecl.php.net \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Composer globalmente
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Criar diretório de trabalho
WORKDIR /var/www/html

# Copiar entrypoint
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Configura usuário www-data com UID/GID do host (ajusta permissões)
RUN groupadd -g ${WWWGROUP} www && useradd -u ${WWWUID} -ms /bin/bash -g www www

# Expor php-fpm socket se for usar socket (ou via TCP)
EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

# Comando padrão (php-fpm)
CMD ["php-fpm"]
