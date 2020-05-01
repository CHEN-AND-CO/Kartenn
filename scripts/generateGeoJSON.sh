#!/bin/bash

set -e

function contours(){
    echo "
    COPY (
        SELECT json_build_object(
            'type', 'FeatureCollection',
            'crs',  json_build_object(
                'type',      'name', 
                'properties', json_build_object(
                    'name', 'EPSG:3857'  
                )
            ), 
            'features', json_agg(
                json_build_object(
                    'type',       'Feature',
                    'id',         osm_id,
                    'geometry',   ST_AsGeoJSON(way)::json,
                    'properties', json_build_object(
                        'name', name,
                        'tags', tags
                    )
                )
            )
        )
        FROM planet_osm_polygon   
        WHERE   \"admin_level\"='8' and 
		        \"name\" is not null and
                \"boundary\"='administrative'
    ) TO STDOUT;
  "
}

db=$1
user=$2
file=$3

psql -d $db -U $user -tq -c "$(contours )" > $file
mapshaper -i $file -clean -simplify 4% weighted keep-shapes -o format=geojson "$file.min.json"
python ./multipolyfix.py "$file.min.json"
ogr2ogr -f "GeoJSON" "wsg84fix.$file.min.json" "fix.$file.min.json" -s_srs EPSG:3857 -t_srs EPSG:4326