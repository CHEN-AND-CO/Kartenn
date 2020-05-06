#!/bin/bash

set -e

host=$1
comment=$2
curdir=$(pwd)

constants=$'export default {
    api_url: "http://'$host':8420/",
    tile_server: "http://'$host'/",
    township_geojson: "wsg84fix.bretagne.geojson.min.json"
};'

apacheConf=$'<VirtualHost *:80>
    '$comment'ServerName '$host'

    DocumentRoot '$curdir'/www
    <Directory '$curdir'/www/>
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet'

dependencies(){
    # APACHE2
    echo "Apache2 installation..."
    sudo apt -y install apache2 certbot
}

configure(){
    echo "$constants" > KartennClient/src/constants.js

    cd KartennClient
    yarn install
    yarn build
    cd ..

    sudo adduser $(whoami) www-data

    sudo mkdir -p www
    sudo cp -r KartennClient/dist/* www
    sudo mkdir -p www/maps
    chmod 777 www/maps
    sudo chown -R www-data:www-data www

    echo "$apacheConf" | sudo tee /etc/apache2/sites-available/kartennClient.conf 
    sudo a2ensite kartennClient.conf
    sudo a2dissite 000-default.conf || :
}

build(){
    sudo systemctl restart apache2
}

dependencies
configure
build