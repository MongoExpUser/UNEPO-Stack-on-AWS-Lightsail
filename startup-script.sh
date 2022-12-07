#...................................................................................................#
#                                                                                                   #
#  @License Starts                                                                                  #
#                                                                                                   #
#  Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.                                  #
#                                                                                                   #
#  License: MIT - https://github.com/MongoExpUser/UNEPO-Stack-on-AWS-Lightsail/blob/main/LICENSE    #
#                                                                                                   #
#  @License Ends                                                                                    #
#                                                                                                   #
#...................................................................................................#
#  startup-script.sh (lauch/start-up script) - performs the following actions:                      #
#  1) Installs additional Ubuntu packages                                                           #
#  2) Installs and configures Node.js v18.x and Express v5.0.0-alpha.8 web server framework         #
#     Installs other node.js packages                                                               #
#  3) Installs postgresql server                                                                    #
#...................................................................................................#


#!/bin/bash

# define all common variable(s)
base_dir="base"
server_dir="server"
client_dir="client"
enable_web_server="yes"
enable_postgresql_server="yes"


create_dir_and_install_missing_packages () {
  # set permssion and create relevant directories
  sudo chmod 777 /home
  sudo chmod 777 /home/ubuntu
  cd /home/
  sudo mkdir $base_dir
  cd $base_dir
  sudo mkdir $server_dir
  sudo mkdir $client_dir
      
  # update system
  sudo apt-get update
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get upgrade
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get dist-upgrade
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
      
  # install additional packages (in case not available in the base image)
  sudo apt-get install sshpass
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install cmdtest
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install spamassassin
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install snap
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install nmap
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install net-tools
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install aptitude
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install build-essential
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install gcc
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install certbot
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install python3-certbot-apache
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install systemd
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install procps
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install nano
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install apt-utils
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install wget
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install curl
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install gnupg
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install gnupg2
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install make
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install sshpass
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install cmdtest
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install snapd
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install screen
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install spamc
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install parted
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install iputils-ping
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install unzip
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get install xfsprogs
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
 
  # aws cli (version 2)
  sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo chmod 777 awscliv2.zip
  sudo unzip awscliv2.zip
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo ./aws/install
  
  #  python 3.8
  sudo apt-get install python3.8
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  
  #  python3-pip
  sudo apt-get install python3-pip
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  
  #  boto3
  sudo python3 -m pip install boto3
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  
  #  awscli & upgrade awscli (version 1)
  sudo apt-get -y install awscli
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo python3 -m pip install --upgrade awscli
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
}

install_and_configure_nodejs_web_server () {
  cd /home/
  cd $base_dir
  
  if [ $enable_web_server = "yes" ]
  then
    # install node.js
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    echo -e "\n"
    sudo apt-get install -y nodejs
    echo -e "\n"
        
    # create node.js' package.json file
    sudo echo ' {
      "name": "Nodejs-Expressjs",
      "version": "1.0",
      "description": "A web server, based on the Node.js-Express.js (NE) stack",
      "license": "MIT",
      "main": "./app.js",
      "email": "info@domain.com",
      "author": "Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.",
      "dependencies"    :
      {
        "express"       : "*"
      },
      "devDependencies": {},
      "keywords": [
        "Node.js",
        "Express.js",
        "PostgreSQL\""
      ]
    }' > package.json
    # a. all modules (except aws modules)
    sudo npm install express@5.0.0-alpha.8
    sudo npm install -g npm
    sudo npm install bcryptjs
    sudo npm install bcrypt-nodejs
    sudo npm install bindings
    sudo npm install bluebird
    sudo npm install body-parser
    sudo npm install command-exists
    sudo npm install compression
    sudo npm install connect-flash
    sudo npm install cookie-parser
    sudo npm install express-session
    sudo npm install formidable
    sudo npm install html-minifier
    sudo npm install level
    sudo npm install memored
    sudo npm install mime
    sudo npm install mkdirp
    sudo npm install ocsp
    sudo npm install pg
    sudo npm install python-shell
    sudo npm install s3-proxy
    sudo npm install s3-node-client
    sudo npm install serve-favicon
    sudo npm install serve-index
    sudo npm install uglify-js2
    sudo npm install uglify-js@2.2.0
    sudo npm install uglifycss
    sudo npm install uuid
    sudo npm install vhost
    sudo npm install @faker-js/faker
    sudo npm install mongodb
    sudo npm install namesilo-domain-api
    sudo npm install xml2js
    # b. all modules of aws sdk for javaScript/node.sj v2
    sudo npm install aws-sdk
    # c. selected modules of aws sdk for javascript/node.sj v3
    sudo npm install @aws-sdk/client-apigatewayv2
    sudo npm install @aws-sdk/client-comprehend
    sudo npm install @aws-sdk/client-comprehendmedical
    sudo npm install @aws-sdk/client-efs
    sudo npm install @aws-sdk/client-elasticache
    sudo npm install @aws-sdk/client-elasticsearch-service
    sudo npm install @aws-sdk/client-firehose
    sudo npm install @aws-sdk/client-lambda
    sudo npm install @aws-sdk/client-lex-model-building-service
    sudo npm install @aws-sdk/client-lex-models-v2
    sudo npm install @aws-sdk/client-lex-runtime-service
    sudo npm install @aws-sdk/client-lex-runtime-v2
    sudo npm install @aws-sdk/client-mq
    sudo npm install @aws-sdk/client-mwaa
    sudo npm install @aws-sdk/client-neptune
    sudo npm install @aws-sdk/client-opensearch
    sudo npm install @aws-sdk/client-polly
    sudo npm install @aws-sdk/client-redshift
    sudo npm install @aws-sdk/client-redshift-data
    sudo npm install @aws-sdk/client-redshiftserverless
    sudo npm install @aws-sdk/client-rekognition
    sudo npm install @aws-sdk/client-rds
    sudo npm install @aws-sdk/client-rds-data
    sudo npm install @aws-sdk/client-s3
    sudo npm install @aws-sdk/client-sns
    sudo npm install @aws-sdk/client-timestream-query
    sudo npm install @aws-sdk/client-timestream-write
    sudo npm install @aws-sdk/client-transcribe
    sudo npm install @aws-sdk/client-transcribe-streaming
    sudo npm install @aws-sdk/client-translate
  fi
}

install_postgresql_server () {
  if [ $enable_postgresql_server = "yes" ]
  then
    # install postgresql latest version
    # 1. create the file repository configuration:
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    # 2. import the repository signing key:
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    # 3. update the package lists:
    sudo apt-get update
    # 4.  finally, install
    sudo apt-get -y install postgresql
    echo -e "Y"
    echo -e "Y"
    
    
    # clean
    sudo rm -rf /var/lib/apt/lists/*
    echo -e "Y"
    echo -e "Y"
    echo -e "Y"
    sudo apt autoclean
    sudo apt autoremove
    
    # by default, postgresql auto starts after installation
    
    # To START or Re-START or STOP PostgreSQL or Check Status of PostgreSQL, use these commands:
    # sudo systemctl start postgresql
    # sudo systemctl restart postgresql
    # sudo systemctl stop postgresql
    # sudo systemctl status postgresql
    
    # To list current active postgresql units, use this command
    # sudo systemctl list-units | grep postgresql
    
    # FOR PRODUCTION deployment, ensures:
    # a) role(s)/user(s) with relevant level of permissions are created
    #    see: https://www.postgresql.org/docs/current/user-manag.html
    # b) other security settings are enabled in the configuration file (/etc/postgresql/version/main/postgresql.conf) - version could be 9.6, 12.6, 14, etc.
    #   important settings with in  'postgresql.conf' include:
    #   ======================================================
    #   listen_addresses = 'localhost'                         # default is 'localhost' but can set to the desired value  as indicatated below.  
    #   listen_addresses = '0.0.0.0'                           # all IPv4 addresses
    #   listen_addresses = '::'                                # all IPv6 addresses
    #   listen_addresses = '*'                                 # all ip (IP4 and IPv6) addresses
    #   host  all           all   0.0.0.0/0    scram-sha-256   # Allow access to all databases for all users with an encrypted password, from all ip4 endpoints
    #   host  replication   all   0.0.0.0/0    scram-sha-256   # Allow replication connections for all users with an encrypted password, from all ip4 endpoint
    #   max_connections = 100                                  # default is 100 but can set to the desired value  
    #   work_mem = 25M                                         # default is 25M but set to = 0.25 x RAM  / max_connections
    #   shared_buffers = 128MB                                 # default is 128MB but set to = 15% to 25% x RAM
    #   maintenance_work_mem = 64MB                            # default is 64MB but set to = 0.05 x RAM and ensure greater than (>) work_mem
    #   autovacuum = on                                        # default 
    #   ======================================================
    #   Note: change 'localhost', '0.0.0.0/0', '::', and '*'  to the desired endpoint(s) -> (ip4 or 1p6)
    
  fi
}

clean_system () {
  sudo chmod 777 /var/lib/apt/lists/
  sudo rm -rf /var/lib/apt/lists/*
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get autoclean
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
  sudo apt-get autoremove
  echo -e "Y"
  echo -e "Y"
  echo -e "Y"
}


main () {
  # execute all functions sequentially
  create_dir_and_install_missing_packages
  install_and_configure_nodejs_web_server
  install_postgresql_server
  clean_system
}

# invoke main
main
