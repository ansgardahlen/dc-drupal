#!/bin/bash

if [[ -f drupal.conf ]]; then
  read -r -p "config file drupal.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv drupal.conf drupal.conf_backup
      ;;
    *)
      exit 1
    ;;
  esac
fi

if [ -z "$DRUPAL_HOSTNAME" ]; then
  read -p "Hostname (FQDN): " -ei "drupal.example.org" DRUPAL_HOSTNAME
fi

if [ -z "$DRUPAL_ADMIN_MAIL" ]; then
  read -p "Drupal admin Mail address: " -ei "mail@example.com" DRUPAL_ADMIN_MAIL
fi

[[ -f /etc/timezone ]] && TZ=$(cat /etc/timezone)
if [ -z "$TZ" ]; then
  read -p "Timezone: " -ei "Europe/Berlin" TZ
fi


DBNAME=drupal
DBUSER=drupal
DBPASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

HTTP_PORT=80
HTTP_BIND_PORT=80


cat << EOF > drupal.conf
# ------------------------------
# drupal web ui configuration
# ------------------------------
# example.org is _not_ a valid hostname, use a fqdn here.
DRUPAL_HOSTNAME=${DRUPAL_HOSTNAME}

# ------------------------------
# DRUPAL admin user
# ------------------------------
DRUPAL_ADMIN=drupaladmin
DRUPAL_ADMIN_MAIL=${DRUPAL_ADMIN_MAIL}
DRUPAL_PASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# ------------------------------
# SQL database configuration
# ------------------------------
DBNAME=${DBNAME}
DBUSER=${DBUSER}

# Please use long, random alphanumeric strings (A-Za-z0-9)
DBPASS=${DBPASS}
DBROOT=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# ------------------------------
# Bindings
# ------------------------------

# You should use HTTPS, but in case of SSL offloaded reverse proxies:
HTTP_PORT=${HTTP_PORT}
HTTP_BIND=0.0.0.0
HTTP_BIND_PORT=${HTTP_BIND_PORT}

# Your timezone
TZ=${TZ}

# Fixed project name
COMPOSE_PROJECT_NAME=dc_wp1

EOF

#if [[ -f data/drupal/web/sites/default/settings.php ]]; then
#  read -r -p "config file settings.php exists and will be overwritten, are you sure you want to contine? [y/N] " response
#  case $response in
#    [yY][eE][sS]|[yY])
#      mv settings.php settings.php.backup
#      ;;
#    *)
#      exit 1
#    ;;
#  esac
##else mkdir -p data/drupal/web/sites/default/
#fi
#
#
##cat << EOF > data/drupal/web/sites/default/settings.php
#cat << EOF > settings.php
#<?php
#\$databases = array();
#\$config_directories = array();
#\$settings['hash_salt'] = 'XpLwStHmPiQyYFa9ES_mivia1zlQL0CNi4-D8qF9ovA2G7rVdLJ9CqT66s1DObw9RWV3vZFE5Q';
#\$settings['update_free_access'] = FALSE;
#if (\$settings['hash_salt']) {
#  \$prefix = 'drupal.' . hash('sha256', 'drupal.' . \$settings['hash_salt']);
#  \$apc_loader = new \Symfony\Component\ClassLoader\ApcClassLoader(\$prefix, \$class_loader);
#  unset(\$prefix);
#  \$class_loader->unregister();
#  \$apc_loader->register();
#  \$class_loader = \$apc_loader;
#}
#\$settings['container_yamls'][] = \$app_root . '/' . \$site_path . '/services.yml';
#\$settings['file_scan_ignore_directories'] = [
#  'node_modules',
#  'bower_components',
#];
#\$config_directories['sync'] = '../config/sync';
#\$config_directories['sync'] = '/var/www/files/config/sync_dir';
#\$databases['default']['default'] = array (
#  'database' => getenv('${DBNAME}'),
#  'username' => getenv('${DBUSER}'),
#  'password' => getenv('${DBPASS}'),
#  'prefix' => '',
#  'host' => 'drupal-db',
#  'port' => '3306',
#  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
#  'driver' => 'mysql',
#);
#\$settings['install_profile'] = 'standard';
#EOF
