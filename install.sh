#!/bin/bash

dependencies() {
    sudo apt update
    sudo apt upgrade -y

    # GENERAL DEPS
    echo "Install tools..."
    sudo apt install -y git wget

    git clone https://github.com/CHEN-AND-CO/KartennClient.git
    git clone https://github.com/CHEN-AND-CO/KartennAPI.git
    git clone https://github.com/CHEN-AND-CO/KartennGenerator.git
}

configure() {
    read -p 'Hostname or domain name: ' hostname
    read -p 'Database name: ' database
    read -p 'MongoDB User: ' kartennapiUser
    read -sp 'MongoDB Password: ' kartennapiPass
    read -p 'PostGis User: ' postgisUser
    read -sp 'PostGis Password: ' postgisPass

    sh install/installKartennClient.sh $hostname
    sh install/installKartennAPI.sh $kartennapiUser $kartennapiPass $hostname
    sh install/installKartennDB.sh $database $postgisUser $postgisPass
    sh install/installKartennGenerator.sh $database $postgisUser $postgisPass
}

dependencies
configure
