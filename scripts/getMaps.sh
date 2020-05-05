#!/bin/bash

set -e

database=$1
dbuser=$2

url="http://overpass.openstreetmap.fr/api/interpreter"
timeout=7200

dependencies(){
    # - Merge tool
    # sudo apt install osmium-tool
    
    # - Get osm file from overpass api
    # wget `$url?data=[timeout:$timeout];(area[name="Morbihan"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O morbihan.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Finistère"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O finistere.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Ille-et-Vilaine"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O ille-et-vilaine.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Côtes-d'Armor"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O cotes-darmor.osm

    # - Fast option for demo
    # wget https://kevin.le-torch.ovh/finistere.osm
    # wget https://kevin.le-torch.ovh/morbihan.osm
    # wget https://kevin.le-torch.ovh/ille-et-vilaine.osm
    # wget https://kevin.le-torch.ovh/cotes-darmor.osm
    
    # - Fastest variant, already merged file (demo only)
    wget http://107.173.229.126/bretagne.osm
}

configure(){

    # - Add files to db
    # osm2pgsql finistere.osm -d $database -U $dbuser --hstore --slim --create
    # osm2pgsql morbihan.osm -d $database -U $dbuser --hstore --slim --append
    # osm2pgsql ille-et-vilaine.osm -d $database -U $dbuser --hstore --slim --append
    # osm2pgsql cotes-darmor.osm -d $database -U $dbuser --hstore --slim --append
    
    # - Merge file into one (faster outside the db) 
    # osmium merge finistere.osm morbihan.osm ille-et-vilaine.osm cotes-darmor.osm -o bretagne.osm

    # Its better to use already merged file
    osm2pgsql bretagne.osm -d $database -U $dbuser --hstore --slim --create
}

dependencies
configure