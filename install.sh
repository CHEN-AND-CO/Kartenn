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
    read -p 'Domain name (Press enter if you do not have one): ' hostname
    if [[ $hostname != $'' ]];
    then
        echo "Domain name config mode"
    else
        read -p 'Hostname name: ' hostname
        comment="#"
    fi
    read -p 'Database name (postgis): ' database
    read -p 'PostGis Password: ' postgisPass
    read -p 'MongoDB User: ' kartennapiUser
    read -p 'MongoDB Password: ' kartennapiPass

    ./install/installKartennDB.sh $database $postgisPass
    ./install/installKartennGenerator.sh $database $postgisPass
    ./install/installKartennAPI.sh $kartennapiUser $kartennapiPass $hostname
    ./install/installKartennClient.sh $hostname $comment
}

dependencies
configure
