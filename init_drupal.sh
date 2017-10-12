#!/bin/sh
#
# Will create a fresh Installation of Drupal
#
source ./drupal.conf
sed ':a;$!N;1,5ba;P;$d;D' data/drupal/web/sites/default/settings.php > data/drupal/web/sites/default/settings.php
docker-compose exec --user 82 php drush -y site-install standard --db-url=mysql://${DBUSER}:${DBPASS}@drupal-db/${DBNAME} --site-name=${DRUPAL_HOSTNAME} --account-name=${DRUPAL_ADMIN} --account-pass=${DRUPAL_PASS} --root=/var/www/html/web/



