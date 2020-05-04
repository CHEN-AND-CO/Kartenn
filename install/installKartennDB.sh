#!/bin/sh

set -e

database=$1
kartuser=$2
kartpass=$3

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

    # PGADMIN4 INSTALL
    echo "PgAdmin4 installation..."
    sudo apt -y install pgadmin4 pgadmin4-apache2
}

configure() {
    echo "Configuring postgres..."
    sudo su - postgres

    read -s -p "New Postgres Password: " postgrespassword
    psql -c "alter user postgres with password '$postgresspassword'"
    createuser -S -R -D $kartuser
    createdb $database -O $kartuser

    exit

    echo "Configuring PostGis..."
    psql -d $database -U $user -tq -c " CREATE EXTENSION postgis;
                                        CREATE EXTENSION postgis_raster;
                                        CREATE EXTENSION postgis_topology;
                                        CREATE EXTENSION postgis_sfcgal;
                                        CREATE EXTENSION fuzzystrmatch;
                                        CREATE EXTENSION address_standardizer;
                                        CREATE EXTENSION address_standardizer_data_us;
                                        CREATE EXTENSION postgis_tiger_geocoder;
                                        CREATE EXTENSION hstore;"

    echo "Adding Data to PostGis"
    sh ./scripts/getMaps.sh $database $kartuser

    echo "Configuring kartenn access..."
    sudo su - postgres
    psql -c "alter user $kartuser with password '$kartpass'"
    exit
}

dependencies
configure