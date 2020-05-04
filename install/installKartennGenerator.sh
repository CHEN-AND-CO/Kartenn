#!/bin/sh

set -e

database=$1
dbuser=$2
dbpass=$3

dependencies(){
    cd KartennGenerator
    ./install.sh
    cd ..
}

configure(){
    dsp=$(mapnik-config --input-plugins)
    config="{
        \"DATASOURCES_PATH\": $dsp,
        \"PSQL_DB\": $database,
        \"PSQL_USER\": $dbuser,
        \"PSQL_PASS\": $dbpass,
    }"

    echo $config > config.json
}

build(){
    cp KartennGenerator/KartennGenerator .
    chmod +x KartennGenerator
}

dependencies
configure
build