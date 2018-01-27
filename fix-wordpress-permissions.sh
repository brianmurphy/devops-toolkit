#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
WP_OWNER=www-data # <-- wordpress owner
WP_GROUP=www-data # <-- wordpress group
WS_GROUP=www-data # <-- webserver group
WP_ROOT=$1 # <-- wordpress root directory
if [ -z "$WP_ROOT" ] ; then
  read -p "Path to WordPress Root: " WP_ROOT
fi

if [ -f ${WP_ROOT}/wp-load.php ]; then
  # reset to safe defaults
  find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
  find ${WP_ROOT} -type d -exec chmod 755 {} \;
  find ${WP_ROOT} -type f -exec chmod 644 {} \;
  if [ -f ${WP_ROOT}/wp-config.php ]; then
     # allow wordpress to manage wp-config.php (but prevent world access)
    chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
    chmod 660 ${WP_ROOT}/wp-config.php
  fi
  # allow wordpress to manage wp-content
  chmod 775 ${WP_ROOT}/wp-content
  find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
  find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
  find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;
else
  echo "wp-config.php now found, "
fi
