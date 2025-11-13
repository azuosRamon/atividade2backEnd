#!/bin/bash
set -e

# Ajusta permissões (não bloqueia se estiver rodando em CI)
chown -R www:www /var/www/html || true
find /var/www/html -type f -exec chmod 644 {} \; || true
find /var/www/html -type d -exec chmod 755 {} \; || true

# Se .env não existir e .env.example existir, copia (útil no PRIMERO START)
if [ -f /var/www/html/.env.example ] && [ ! -f /var/www/html/.env ]; then
  cp /var/www/html/.env.example /var/www/html/.env
fi

# Se vendor inexistente, tenta instalar (somente se pasta montada e composer disponível)
if [ ! -d /var/www/html/vendor ]; then
  echo "vendor not found — rodando composer install (pode demorar)..."
  cd /var/www/html || exit 0
  composer install --no-interaction --prefer-dist --optimize-autoloader || true
fi

exec "$@"
