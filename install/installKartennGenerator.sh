#!/bin/bash

set -e

database=$1
dbuser=$(whoami)
dbpass=$2

dependencies(){
    cd Generator
    ./install.sh
    cd ..
}

configure(){
    dsp=$(mapnik-config --input-plugins)
    config='{
    "DATASOURCES_PATH": "'$dsp'",
    "PSQL_DB": "'$database'",
    "PSQL_USER": "'$dbuser'",
    "PSQL_PASS": "'$dbpass'"
}'

    echo "$config" > KartennAPI/config.json
}

build(){
    cp Generator/build/KartennGenerator KartennAPI/
    chmod +x KartennAPI/KartennGenerator
}

dependencies
configure
build