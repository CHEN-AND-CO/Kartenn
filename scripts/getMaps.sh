#!/bin/sh

set -e

database=$1
dbuser=$2

url="http://overpass.openstreetmap.fr/api/interpreter"
timeout=7200

dependencies(){
    # wget `$url?data=[timeout:$timeout];(area[name="Morbihan"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O morbihan.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Finistère"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O finistere.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Ille-et-Vilaine"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O ille-et-vilaine.osm
    # wget `$url?data=[timeout:$timeout];(area[name="Côtes-d'Armor"][admin_level="6"];)->.a;(node(area.a);<;);out meta;` -O cotes-darmor.osm

    wget https://kevin.le-torch.ovh/finistere.osm
    wget https://kevin.le-torch.ovh/morbihan.osm
    wget https://kevin.le-torch.ovh/ille-et-vilaine.osm
    wget https://kevin.le-torch.ovh/cotes-darmor.osm
}

configure(){
    osm2pgsql finistere.osm -d $database -U $dbuser --hstore --slim --create
    osm2pgsql morbihan.osm -d $database -U $dbuser --hstore --slim --append
    osm2pgsql ille-et-vilaine.osm -d $database -U $dbuser --hstore --slim --append
    osm2pgsql cotes-darmor.osm -d $database -U $dbuser --hstore --slim --append
}

dependencies
configure