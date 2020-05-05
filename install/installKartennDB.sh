#!/bin/bash

set -e

database=$1
kartuser=$(whoami)
kartpass=$2

dependencies() {
    sudo apt -y install gnupg2

    # POSTGRES INSTALL
    echo "Postgres installation..."
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
    sudo apt update
    sudo apt -y install postgresql-12 postgresql-client-12

    # POSTGIS INSTALL
    echo "PostGis installation..."
    sudo apt -y install postgresql-12-postgis-* postgis* osm2pgsql
    sudo pg_ctlcluster 12 main start

    # PGADMIN4 INSTALL
    echo "PgAdmin4 installation..."
    sudo apt -y install pgadmin4 pgadmin4-apache2
}

configure() {
    echo "Configuring postgres..."
    # sudo -u postgres -H psql -c "alter user postgres with password '$postgrespassword'"
    sudo -u postgres -H sh -c "createuser -S -R -D $kartuser" || :
    sudo -u postgres -H sh -c "createdb $database -O $kartuser" || :

    echo "Configuring PostGis..."
    sudo -u postgres -H psql -d $database -tq -c "CREATE EXTENSION postgis;
                                        CREATE EXTENSION postgis_raster;
                                        CREATE EXTENSION postgis_topology;
                                        CREATE EXTENSION postgis_sfcgal;
                                        CREATE EXTENSION fuzzystrmatch;
                                        CREATE EXTENSION address_standardizer;
                                        CREATE EXTENSION address_standardizer_data_us;
                                        CREATE EXTENSION postgis_tiger_geocoder;
                                        CREATE EXTENSION hstore;"

    echo "Adding Data to PostGis"
    ./scripts/getMaps.sh $database $kartuser

    echo "Configuring kartenn access..."
    sudo -u postgres -H psql -c "alter user $kartuser with password '$kartpass'"
}

dependencies
configure