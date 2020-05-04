#!/bin/sh

set -e

apiuser=$1
apipass=$2
host=$3
curdir=$(pwd)

consts="        
    var consts = {
        host: \"localhost\",                          
        db: \"kartenn_api\",                         
        authSource: \"admin\",                      
        user: \"$apiuser\",                         
        pass: \"$apipass\",               
        SSLCertificateFile: \"./fullchain.pem\",    
        SSLCertificateKeyFile: \"./privkey.pem\",
        https: false,
        outputDir: \"$curdir/www/maps/\",    
        generatorPath: \"$curdir/KartennGenerator\",         
        mapsUrl: \"http://$host/maps/\"
    };

    module.exports = consts;"

dependencies() {
    sudo apt update
    sudo apt -y install nano bash-completion wget dirmngr gnupg apt-transport-https software-properties-common ca-certificates curl screen
    sudo apt -y upgrade

    # NVM & NODEJS & YARN
    echo "Nvm, nodejs and yarn installation..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install node
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
    sudo apt -y install yarn

    # MONGODB INSTALL
    echo "Tries to install MongoDB (tested for Debian 10 (Buster) here), if that's not working, please follow the installation instructions according to you distro here : https://docs.mongodb.com/manual/administration/install-community/"
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
    echo "Adding MongoDB Repo to APT, if that doesn't work, change the repo"
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl enable mongod
    sudo systemctl start mongod
    yarn install
}

configure() {
    echo "Configuring your MongoDB database..."
    node ./scripts/mongoDBConf.js $apiuser $apipass
    echo "Copying auth enabled conf..."
    sudo cp -f ./conf/mongod.conf /etc/mongod.conf
    echo "Restarting MongoDB"
    sudo systemctl restart mongod

    echo "Creating KartennAPI service..."
    sh ./scripts/createKartennAPIService.sh $curdir
    echo "KartennAPI is now accessible on screen -r kartennAPI"

    echo $consts > KartennAPI/config/consts.js
}

build() {
    sudo systemctl start kartennapi
}

dependencies
configure
build
