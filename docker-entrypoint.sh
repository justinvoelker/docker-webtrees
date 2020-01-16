#!/bin/sh

NGINX_CONFIG_FILE=/etc/nginx/nginx.conf

# Update server_name in nginx config as webtrees relies on it for redirections
sed -i "s/server_name localhost;/server_name ${SERVER_NAME};/" ${NGINX_CONFIG_FILE}

# If the data directory is created as a mount point, it will not have the proper permissions or default content. Setup the data directory.
cp -r /var/www/html/data.bak/. /var/www/html/data
chown www-data /var/www/html/data
chmod g+w /var/www/html/data


# Pull data directory content from git if data directory is empty


# Start supervisord and services
/usr/bin/supervisord -c /etc/supervisord.conf

exec "$@"
