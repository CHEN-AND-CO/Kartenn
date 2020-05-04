#!/bin/bash

dependencies() {
    sudo apt update
    sudo apt upgrade -y

    # GENERAL DEPS
    echo "Install tools..."
    sudo apt install -y git wget

    git clone https://github.com/CHEN-AND-CO/KartennAPI.git
    git clone https://github.com/CHEN-AND-CO/KartennGenerator.git Generator
    git clone https://github.com/CHEN-AND-CO/KartennClient.git
}

configure() {
    read -p 'Hostname or domain name: ' hostname
    read -p 'Database name: ' database
    read -p 'MongoDB User: ' kartennapiUser
    read -p 'MongoDB Password: ' -s kartennapiPass
    read -p 'PostGis User: ' postgisUser
    read -p 'PostGis Password: ' -s postgisPass

    ./install/installKartennAPI.sh $kartennapiUser $kartennapiPass $hostname
    ./install/installKartennClient.sh $hostname
    ./install/installKartennDB.sh $database $postgisUser $postgisPass
    ./install/installKartennGenerator.sh $database $postgisUser $postgisPass
}

dependencies
configure
