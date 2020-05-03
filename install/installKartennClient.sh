#!/bin/sh

set -e

host=$1
curdir=$(pwd)

constants="
export default {
    api_url: \"http://$host:8420/\",
    tile_server: \"http://$host/\",
    township_geojson: \"wsg84fix.bretagne.geojson.min.json\"
};"

apacheConf="
    <VirtualHost *:80>
	    ServerName $host

	    DocumentRoot $curdir/www

	    ErrorLog \${APACHE_LOG_DIR}/error.log
	    CustomLog \${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet"

dependencies(){
    # APACHE2
    echo "Apache2 installation..."
    sudo apt -y install apache2 certbot
}

configure(){
    echo $constants > KartennClient/src/constants.js

    cd KartennClient
    yarn install
    yarn build
    cd ..

    mkdir -p www
    cp -r KartennClient/dist wwww
    mkdir -p www/maps

    sudo chown -R www-data:www-data www
    sudo $apacheConf > /etc/apache2/sites-available/kartennClient.conf
    sudo a2ensite kartennClient.conf
}

build(){

}

dependencies
configure
build